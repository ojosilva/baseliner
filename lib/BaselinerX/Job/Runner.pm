package BaselinerX::Job::Runner;
use Baseliner::Plug;
use Baseliner::Utils;

	has 'jobid' => ( is=>'rw', isa=>'Int' );
	has 'name' => ( is=>'rw', isa=>'Str' );
	has 'logger' => ( is=>'rw', isa=>'Object' );
no Moose;

register 'config.job.runner' => {
	metadata => [
		{ id=>'root', default=> do { $ENV{BASELINER_TEMP} || $ENV{TEMP} || File::Spec->tmpdir() } },
	]
};
register 'service.job.run' => { name => 'Job Runner', config => 'config.job', handler => \&job_run, };
register 'service.job.runner.simple.chain' => { name => 'Simple Chain Job Runner', config => 'config.job', handler => \&job_simple_chain, };

register 'service.job.init' => { name => 'Job Runner Initializer', config => 'config.job.runner', handler => \&job_init, };
register 'service.job.contents' => { name => 'Job Contents Runner', config => 'config.job.runner', handler => \&job_contents, };
# executes jobs sent by the daemon in an independent process
sub job_run {
	my ($self,$c,$config)=@_;
	my $jobid = $config->{jobid};
	$c->stash->{job} = $self;
	$self->jobid( $jobid );
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
			my $r = $c->model('Baseliner::BaliJob')->search({ id=>$jobid })->first;
			$self->name( $r->name );
			$self->{job_data} = { $r->get_columns };
			$c->launch( $config->{runner} ); 
			$self->logger->info( 'Pase finalizado');
		};
		unless( $@ ) {
			my $r = $c->model('Baseliner::BaliJob')->search({ id=>$jobid })->first;
			$r->status('FINISHED');
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

sub job_simple_chain {
	my ($self,$c,$config)=@_;

	my $job = $c->stash->{job};
	my $log = $job->logger;

	$log->debug('Iniciando Simple Chain Runner PID=' . $job->{job_data}->{pid} );

	my $chain = $c->model('Baseliner::BaliChain')->search({ id=> 1})->first;
	my $rs_chain = $c->model('Baseliner::BaliChainedService')->search({ chain_id=>$chain->id }, { order_by=>'seq' });
	while( my $r = $rs_chain->next ) {
		$log->debug('Running Service ' . $r->key);
		$c->launch( $r->key );
	}
}

use File::Spec;
sub job_init {
	my ($self,$c,$config)=@_;
	
	my $job = $c->stash->{job};
	my $log = $job->logger;

	my $job_dir = File::Spec->catdir( $config->{root}, $job->name );
	$log->debug( 'Creando directorio de pase ' . $job_dir );
	unless( -e $job_dir ) {
		mkdir $job_dir;
	}
	$job->{path} = $job_dir;
}

sub job_contents {
	my ($self,$c,$config)=@_;
	
	my $job = $c->stash->{job};
	my $log = $job->logger;

	$log->debug( 'Job Contents cargando, path=' . $job->{path} );
	my $rs =$c->model('Baseliner::BaliJobItems')->search({ id_job=> $job->jobid }); 
	my %cont;
	while( my $r = $rs->next ) {
		$log->debug('Cargando contenido de pase para id=' . $r->id );
		# load vars with contents
		push @{ $job->{contents} }, { $r->get_columns };
		# group contents
		$cont{ $r->service } = 1;
	}
	# call each content service
	foreach my $service ( keys %cont ) {
		next unless $service;
		$log->debug('Iniciando servicio de contenido de pase: ' . $service );
		$c->launch( $service );
	}
}

1;
