package BaselinerX::Job;
use Baseliner::Plug;
use Baseliner::Utils;
use TheSchwartz::Moosified;
use DateTime;
use YAML;

BEGIN { extends 'Catalyst::Controller' }
use JavaScript::Dumper;

register 'config.job.daemon' => {
	metadata=> [
		{  id=>'frequency', label=>'Job Server Frequency', type=>'int', default=>10 },
	]
};

register 'config.job.schartz' => {
	metadata=> [
		{ id=>'service', label=>'Service Name', type=>'text' },
		{ id=>'worker', label=>'Worker', type=>'text' },
		{ id=>'verbose', label=>'Verbose', type=>'text' },
		{ id=>'tz', label=>'TimeZone', type=>'text' },		
		{ id=>'start', type=>'date' },
		{ id=>'until', type=>'date' },
		{ id=>'run_after', type=>'int' },
		{ id=>'grabbed_until', type=>'text' },
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
		{ id=>'comment', label => 'Comment', type=>'text' },
	],
	relationships => [ { id=>'natures', label => 'Technologies', type=>'list', config=> 'config.tech' },
		{ id=>'releases', label => 'Releases', type=>'list', config=> 'config.release' },
		{ id=>'apps', label => 'Applications', type=>'list', config=> 'config.app' },
		{ id=>'rfcs', label => 'RFCs', type=>'list', config=>'config.rfc' },
	],
};

register 'menu.job' => { label => 'Jobs' };
register 'menu.job.create' => { label => 'Create a new Job', url=>'hello.mas' };
#register 'menu.job.list' => { label => 'List Current Jobs', url=>'/maqueta/list.mas', title=>'Job Monitor' };
#register 'menu.job.exec' => { label => 'Exec Current Jobs', url_run=>'/maqueta/list.mas', title=>'Job Monitor' };
register 'menu.job.hist' => { label => 'Historical Data', handler => 'function(){ Ext.Msg.alert("Hello"); }' };
register 'menu.job.list' => { label => 'Monitor', url_comp => '/job/monitor', title=>'Monitor' };
register 'menu.job.hist.all' => { label => 'List all Jobs', url=>'/core/registry', title=>'Registry'  };

register 'service.job.create' => {
	name => 'Schedule a new job',
	config => 'config.job.schartz',
	handler => sub {
		my ($self,$c)=@_;
		my $client = TheSchwartz::Moosified->new( verbose => 1);
		$c->model('DBIC')->storage->dbh_do(
			sub {
				my ($storage, $dbh) = @_;
				$client->databases([$dbh]) or die $!;
			} );

		use Date::Manip; 
		Date_Init( "TZ=" . $b->{'config.job.tz'} ) if($b->{'config.job.tz'});
		my $run_after = $b->{'config.job.run_after'} || UnixDate(ParseDate($b->{'config.job.start'}, '%s' ));
		## schedule a job
		my $job = TheSchwartz::Moosified::Job->new(
			funcname => $b->{'config.job.worker'},
			run_after=> $run_after,  ## run_after expects a secs since epoch value
			  ## you may also wanna set grabbed_until
			arg      => [ foo => 'bar' ],
		);
		$client->insert($job) or die $!;
		$client->can_do($b->{'config.job.worker'});
		$client->work();
	}
};

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

sub job_run {
	my ($self,$c,$config)=@_;
	warn "Running JOB=" . $config->{jobid};
	warn "Running Chain=" . $config->{chain};
}

use Proc::Background;
sub job_daemon {
	my ($self,$c,$config)=@_;
	my $freq = $config->{frequency};
	while(1) {
		my $now = DateTime->now;
		$now->set_time_zone('CET');
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
			my $cmd = "perl $0 job.run jobid=" . $r->id;
			my $proc = Proc::Background->new( $cmd );
		}
		sleep $freq;	
	}
}

sub create_job {
	my ($self,$c,$config)=@_;
	my $jobid = $config->{jobid} || 'N.000010101';
	my $status = $config->{status};
	#my $rs = $c->model('Harvest::Harpackage')->search();
	#while( my $r = $rs->next ) {
	#	warn "P=" . $r->packagename
	#}
	#$c->inf_write( ns=>'/job', bl=>'DESA', key=>'config.job.jobid', value=>$jobid ); 	
	warn "Create JOB $jobid";
	my $now = DateTime->now;
	$now->set_time_zone('CET');
	my $end = $now->clone->add( hours => 1 );
    $ENV{'NLS_DATE_FORMAT'} = 'YYYY-MM-DD HH24:MI:SS';
    my $ora_now =  $now->strftime('%Y-%m-%d %T');
    my $ora_end =  $end->strftime('%Y-%m-%d %T');
    #require DateTime::Format::Oracle;
    #my $ora_now = DateTime::Format::Oracle->format_datetime( $now );
    #my $ora_end = DateTime::Format::Oracle->format_datetime( $end );
    #warn "ORA=$ora_now";
	my $job = $c->model('balijob')->create({ name=>'temp', starttime=> $ora_now, endtime=>$ora_end, maxstarttime=>$ora_end, status=> $status, ns=>'/sct', bl=>'TEST' });
	$job->name( $jobid . $now );
	$job->update;
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