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
		{ id=>'runner', label => 'Registry Entry to run', type=>'text', default=>'service.job.dummy' },
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

register 'service.job.daemon' => {
	name => 'Watch for new jobs',
	config => 'config.job.daemon',
	handler => \&job_daemon,
};

register 'service.job.run' => {
	name => 'Watch for new jobs',
	config => 'config.job',
	handler => \&job_run,
};
register 'service.job.dummy' => {
	name => 'A Dummy Job',
	handler => sub {
		my ($self,$c)=@_;
		warn "DUMMY";
		$c->log->info("A dummy job is running");
	}
};

has 'jobid' => ( is=>'rw', isa=>'Int' );
has 'logger' => ( is=>'rw', isa=>'Object' );

sub job_run {
	my ($self,$c,$config)=@_;
	my $jobid = $config->{jobid};
	$c->stash->{job} = $self;
	$self->logger( new BaselinerX::Job::Log({ jobid=>$jobid }) );
	warn "Running JOB=" . $jobid;
	if( $config->{chain} ) {  ## a chain has precedence over a single service
		$c->log->debug("Running Chain=" . $config->{chain} ); 
		my $chain = $c->registry->get( $config->{chain} );
		$chain->go;
	}
	elsif( $config->{runner} ) {
		$c->log->debug("Running Service=" . $config->{runner} ); 
		eval {
		$c->launch( $config->{runner} ); 
		};
		unless( $@ ) {
			my $r = $c->model('Baseliner::BaliJob')->search({ id=>$jobid })->first;
			$r->status('DONE');
			$r->update;
		} else {
			_log "*** Error running Job $jobid ****";
			_log $@;
			$self->logger->error( $@ );
			my $r = $c->model('Baseliner::BaliJob')->search({ id=>$jobid })->first;
			$r->status('ERROR');
			$r->update;
		}
	}
	else {
		Catalyst::Exception->throw( "No job chain or service defined for job " . $config->{jobid} );
	}
}

use Proc::Background;
sub job_daemon {
	my ($self,$c,$config)=@_;
	my $freq = $config->{frequency};
	while(1) {
        my $now = _now;
		my @rs = $c->model('balijob')->search({ 
			starttime => { '<' , $now }, 
			maxstarttime => { '>' , $now }, 
			status => 'READY',
			});
			if( ! @rs ) { 
				warn "No jobs found for '$now'";	
			}
		foreach my $r ( @rs ) {
			warn "Starting job ". $r->name;
			$r->status('RUNNING');
			$r->update;
			warn "$0 :: @ARGV";
			my $cmd = "perl $0 job.run runner=\"". $r->runner ."\" jobid=". $r->id;
			my $proc = Proc::Background->new( $cmd );
		}
        $self->job_expired($c);
		sleep $freq;	
	}
}

sub job_expired {
	my ($self,$c)=@_;
    _log( "Checking for expired jobs..." );
    my @rs = $c->model('balijob')->search({ 
			maxstarttime => { '<' , _now }, 
			status => 'READY',
    });
    foreach my $row ( @rs ) {
        _log( "Job $row->{name} expired (maxstartime=$row->{maxstarttime}");
        $row->status('EXPIRED');
        $row->update;
    }
    return;
}

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
	my $job = $c->model('Baseliner::BaliJob')->create({ name=>'temp'.$$, starttime=> $ora_now, endtime=>$ora_end, maxstarttime=>$ora_end, status=> $status, ns=>'/sct', bl=>'TEST' });
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
	$c->forward('/namespace/load_namespaces');
	$c->forward('/baseline/load_baselines_no_root');
    $c->stash->{template} = '/comp/job_new.mas';
}

sub job_items_json : Path('/job/items/json') {
    my ( $self, $c ) = @_;
	my $p = $c->req->params;
	use Baseliner::Core::Namespace;
	my @ns_list = Baseliner::Core::Namespace->namespaces({ can_job=>1, bl=>$p->{bl}, job_type=>$p->{job_type}, query=>$p->{query} });
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
	my $rs = $c->model('Baseliner::Balijob')->search();
	my @rows;
	while( my $r = $rs->next ) {
		push @rows, { jobid=>$r->id, name=>$r->name, starttime=>$r->starttime, endtime=>$r->endtime  };
	}
	$c->stash->{json} = { cat => \@rows };	
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
	my $runner = 'service.job.simple';  #TODO from config
	my $job_name;
	eval {
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
                ns           => '/',
                bl           => $bl,
            }
        );
		$job_name = job_name({ mask=>'%s.%s%08d', type=>$job_type, bl=>$bl, id=>$job->id });
		$job->name( $job_name );
		$job->update;
		# create job items
		for my $item ( @{ $contents || [] } ) {
			warn Dump $item;
			my $items = $c->model('Baseliner::BaliJobItems')->create({
				data => YAML::Dump($item->{data}),
				item => $item->{item},
				runner => $runner, 
				provider => $item->{provider}, 
				id_job => $job->id,
			});
		}
		# let it run
		$job->status( 'READY' );
		$job->update;
	};
	if( $@ ) {
		$c->stash->{json} = { success => \0, msg => _loc("Error creating the job: %1", $@) };
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
    $c->stash->{url_store} = '/job/monitor_json';
    $c->stash->{url_add} = '/job/new';
    $c->stash->{title} = $c->localize('Job Monitor');
    $c->stash->{columns} = js_dumper $config->grid_columns;
    $c->stash->{fields} = js_dumper $config->grid_fields;

#{  ##TODO this should come from config->metadata fields
#        jobid      => { header => 'JobId', width=>200 },
#        start_date => { header => 'StartDate' },
#        end_date   => { header => 'EndDate' },
#        status     => { header => 'Status' },
#        last_log   => { header => 'LastLog' }
#    };
    $c->stash->{ordered_fields} = [$config->column_order];
    $c->stash->{template} = '/comp/grid.mas';
}

1;
