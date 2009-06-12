package BaselinerX::Job;
use Baseliner::Plug;
use Baseliner::Utils;
use DateTime;
use YAML;

# comment
#  otro

BEGIN { extends 'Catalyst::Controller' }
BEGIN { 
    ## Oracle needs this
    $ENV{'NLS_DATE_FORMAT'} = 'YYYY-MM-DD HH24:MI:SS';
}
use JavaScript::Dumper;

register 'config.job.daemon' => {
	metadata=> [
		{  id=>'frequency', label=>'Job Server Frequency', type=>'int', default=>10 },
	]
};

register 'config.job' => {
	metadata=> [
		{ id=>'jobid', label => 'Job ID', type=>'text', width=>200 },
		{ id=>'name', label => 'Job Name', type=>'text', width=>180 },
		{ id=>'starttime', label => 'StartDate', type=>'text', },
		{ id=>'maxstarttime', label => 'MaxStartDate', type=>'text', },
		{ id=>'endtime', label => 'EndDate', type=>'text' },
		{ id=>'status', label => 'Status', type=>'text', default=>'READY' },
		{ id=>'mask', label => 'Job Naming Mask', type=>'text', default=>'%s.%s-%08d' },
		{ id=>'runner', label => 'Registry Entry to run', type=>'text', default=>'service.job.runner.simple.chain' },
		{ id=>'comment', label => 'Comment', type=>'text' },
	],
	relationships => [ { id=>'natures', label => 'Technologies', type=>'list', config=> 'config.tech' },
		{ id=>'releases', label => 'Releases', type=>'list', config=> 'config.release' },
		{ id=>'apps', label => 'Applications', type=>'list', config=> 'config.app' },
		{ id=>'rfcs', label => 'RFCs', type=>'list', config=>'config.rfc' },
	],
};

register 'menu.job' => { label => _loc('Jobs') };
register 'menu.job.create' => { label => _loc('Create a new Job'), url=>'/job/create', title=>_loc('New Job') };
#register 'menu.job.list' => { label => 'List Current Jobs', url=>'/maqueta/list.mas', title=>'Job Monitor' };
#register 'menu.job.exec' => { label => 'Exec Current Jobs', url_run=>'/maqueta/list.mas', title=>'Job Monitor' };
#register 'menu.job.hist' => { label => 'Historical Data', handler => 'function(){ Ext.Msg.alert("Hello"); }' };
register 'menu.job.list' => { label => 'Monitor', url_comp => '/job/monitor', title=>'Monitor' };
#register 'menu.job.hist.all' => { label => 'List all Jobs', url=>'/core/registry', title=>'Registry'  };

register 'service.job.new' => {
	name => 'Schedule a new job',
	config => 'config.job',
	handler => \&create_job,
};

# TODO to config, or to the final .mas file...
our %type_to_text = ( 'promote' => 'normal', 'demote' => 'rollback' );

sub job_name {
	my $p = shift;
	my $prefix = $p->{type} eq 'promote' ? 'N' : 'B';
	return sprintf( $p->{mask}, $prefix, $p->{bl} eq '*' ? 'ALL' : $p->{bl} , $p->{id} );
}

sub create_job {
	my ($self,$c,$config)=@_;
	my $status = $config->{status};
	#my $rs = $c->model('Harvest::Harpackage')->search();
	#while( my $r = $rs->next ) {
	#	warn "P=" . $r->packagename
	#}
	#$c->inf_write( ns=>'/job', bl=>'DESA', key=>'config.job.jobid', value=>$jobid ); 	
	my $now = DateTime->now;
	$now->set_time_zone('CET');
	my $end = $now->clone->add( hours => 1 );
    my $ora_now =  $now->strftime('%Y-%m-%d %T');
    my $ora_end =  $end->strftime('%Y-%m-%d %T');
    #require DateTime::Format::Oracle;
    #my $ora_now = DateTime::Format::Oracle->format_datetime( $now );
    #my $ora_end = DateTime::Format::Oracle->format_datetime( $end );
    #warn "ORA=$ora_now";
	my $job = $c->model('Baseliner::BaliJob')->create({ name=>'temp'.$$, starttime=> $ora_now, endtime=>$ora_end, maxstarttime=>$ora_end, status=> $status, ns=>'/', bl=>'*' });
	my $name = $config->{name} 
        || job_name({ mask=>$config->{mask}, type=>'promote', bl=>$c->inf_bl, id=>$job->id });
	$config->{runner} && $job->runner( $config->{runner} );
	#$config->{chain} && $job->chain( $config->{chain} );
	warn "Creating JOB $name";
	$job->name( $name );
	$job->update;
	return $name;
}

sub job_create : Path('/job/create')  {
    my ( $self, $c ) = @_;
	$c->forward('/namespace/load_namespaces'); # all namespaces
	$c->forward('/baseline/load_baselines_no_root');
    $c->stash->{template} = '/comp/job_new.mas';
}

sub job_items_json : Path('/job/items/json') {
    my ( $self, $c ) = @_;
	my $p = $c->req->params;
	use Baseliner::Core::Namespace;
	my $cache_key = join '_', 'ns_list',%{ $p };
	my @ns_list;
	if( my $cache_list = $c->cache->get( $cache_key ) ) {
		@ns_list = @{ $cache_list || [] };
	} else {
		@ns_list = Baseliner::Core::Namespace->namespaces({ can_job=>1, bl=>$p->{bl}, job_type=>$p->{job_type}, query=>$p->{query} });
		$c->cache->set($cache_key, \@ns_list );
	}
	my @job_items;
	my $cnt=1;
	for my $n ( @ns_list ) {
        push @job_items,
          {
			id => $cnt++,
            provider => $n->ns_type,
            icon     => $n->icon,
            item     => $n->ns_name,
            ns       => $n->ns,
            user     => $n->user,
            service  => $n->service,
            text     => $n->ns_info,
            date     => $n->date,
            data     => $n->ns_data
          };
	}
	$c->stash->{json} = {
		totalCount => scalar @job_items,
		data => [ @job_items ]
	};
	$c->forward('View::JSON');
}

sub monitor_json : Path('/job/monitor_json') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
    my $query = $p->{query};
	my $dir = lc( $p->{dir} );
	my $order_by = $query ? { "-$dir" => $p->{sort} } : { -desc => 'id' } ;
	my $rs = $c->model('Baseliner::BaliJob')->search(undef, { order_by => $order_by });
	my @rows;
	while( my $r = $rs->next ) {
        next if( $query && !query_array($query, $r->name, $r->comments, $r->type, $r->bl ));
        push @rows,
          {
            id        => $r->id,
            name      => $r->name,
            bl      => $r->bl,
            bl_text      => $r->bl,   #TODO resolve bl name
            starttime => $r->get_column('starttime'),
            maxstarttime => $r->get_column('maxstarttime'),
            endtime   => $r->get_column('endtime'),
            comments   => $r->get_column('comments'), 
            status   => _loc($r->status), 
            status_code  => $r->status, 
            type   => $r->type, 
            runner   => $r->runner, 
          };
	}
	$c->stash->{json} = { 
        totalCount=> scalar \@rows,
        data => \@rows
     };	
	$c->forward('View::JSON');
}

sub monitor_json_from_config : Path('/job/monitor_json_from_config') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	my $config = $c->registry->get( 'config.job' );
	my @rows = $config->rows( query=> $p->{query}, sort_field=> $p->{'sort'}, dir=>$p->{dir}  );
	#my @jobs = qw/N0001 N0002 N0003/;
	#push @rows, { job=>$_, start_date=>'22/10/1974', status=>'Running' } for( $p->{dir} eq 'ASC' ? reverse @jobs : @jobs );
	$c->stash->{json} = { cat => \@rows };	
	$c->forward('View::JSON');
}

use JSON::XS;
sub job_submit : Path('/job/submit') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	my $config = $c->registry->get('config.job')->data;
	my $runner = $config->{runner};
	my $job_name;
	eval {
		if( $p->{action} eq 'delete' ) {
			my $job = $c->model('Baseliner::BaliJob')->search({ id=> $p->{id_job} })->first;
			die _loc('Job %1 is currently running and cannot be deleted')
				unless( $job->status =~ m/READY|INEDIT|FINISHED|ERROR|KILLED/ );
			$job->delete;
		}
		elsif( $p->{action} eq 'rerun' ) {
			my $job = $c->model('Baseliner::BaliJob')->search({ id=> $p->{id_job} })->first;
			die _loc('Job %1 not found.', $p->{id_job} ) unless $job;
			die _loc('Job %1 is currently running (%2) and cannot be rerun', $job->name, $job->status)
				unless( $job->status =~ m/READY|INEDIT|FINISHED|ERROR|KILLED/ );

			my $now = DateTime->now;
			$now->set_time_zone('CET');
			my $end = $now->clone->add( hours => 1 );
			my $ora_now =  $now->strftime('%Y-%m-%d %T');
			my $ora_end =  $end->strftime('%Y-%m-%d %T');
			$job->starttime( $ora_now );
			$job->maxstarttime( $ora_end );
			$job->status( 'READY' );
			$job->update;
		}
		else {
			my $bl = $p->{bl};
			my $comments = $p->{comments};
			my $job_date = $p->{job_date};
			my $job_time = $p->{job_time};
			my $job_type = $p->{job_type};
			my $contents = decode_json $p->{job_contents};
			die _loc('No job contents') if( !$contents );
			# create job
			my $start = parse_date('dd/mm/Y', "$job_date $job_time");
			#$start->set_time_zone('CET');
			my $end = $start->clone->add( hours => 1 );
			my $ora_start =  $start->strftime('%Y-%m-%d %T');
			my $ora_end =  $end->strftime('%Y-%m-%d %T');
			my $job = $c->model('Baseliner::BaliJob')->create(
				{
					name         => 'temp' . $$,
					starttime    => $ora_start,
					endtime      => $ora_end,
					maxstarttime => $ora_end,
					status       => 'IN EDIT',
					type         => $type_to_text{ $job_type },
					ns           => '/',
					bl           => $bl,
					runner       => $runner,
					comments     => $comments,
				}
			);
			$job_name = job_name({ mask=>'%s.%s%08d', type=>$job_type, bl=>$bl, id=>$job->id });
			$job->name( $job_name );
			$job->update;
			# create job items
			my @item_list;
			for my $item ( @{ $contents || [] } ) {
				warn Dump $item;
				my $items = $c->model('Baseliner::BaliJobItems')->create({
					data => YAML::Dump($item->{data}),
					item => $item->{item},
					service => $item->{service}, 
					provider => $item->{provider}, 
					id_job => $job->id,
				});
				push @item_list, '<li>'.$item->{item}.' ('.$item->{provider}.')';
			}
			# log job items
			my $log = new BaselinerX::Job::Log({ jobid=>$job->id });
			$log->info('Contenido del pase', join'',@item_list );

			# let it run
			$job->status( 'READY' );
			$job->update;
		}
	};
	if( $@ ) {
        warn $@;
		$c->stash->{json} = { success => \0, msg => _loc("Error creating the job: ").$@ };
	} else {
		$c->stash->{json} = { success => \1, msg => _loc("Job %1 created.", $job_name) };
	}
	$c->forward('View::JSON');	
}

sub job_new : Path('/job/new') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	$c->res->body( '<pre' . Dump $p );
	##$self->create_job( $c, $p );
}

sub monitor : Path('/job/monitor') {
    my ( $self, $c ) = @_;
    $c->languages( ['es'] );
	my $config = $c->registry->get( 'config.job' );
    $c->stash->{template} = '/comp/monitor_grid.mas';
}

1;
