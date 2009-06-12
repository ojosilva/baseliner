package BaselinerX::Job::Daemon;
use Baseliner::Plug;
use Baseliner::Utils;

register 'service.job.daemon' => { name => 'Watch for new jobs', config => 'config.job.daemon', handler => \&job_daemon, };
register 'service.job.dummy' => {
	name => 'A Dummy Job',
	handler => sub {
		my ($self,$c)=@_;
		warn "DUMMY";
		$c->log->info("A dummy job is running");
	}
};

# daemon - listens for new jobs
use Proc::Background;
use Proc::Exists qw(pexists);
sub job_daemon {
	my ($self,$c,$config)=@_;
	my $freq = $config->{frequency};
	while(1) {
        my $now = _now;
		my @rs = $c->model('Baseliner::BaliJob')->search({ 
			starttime => { '<' , $now }, 
			maxstarttime => { '>' , $now }, 
			status => 'READY',
			});
			if( ! @rs ) { 
				_log "No jobs found for '$now'";	
			}
		foreach my $r ( @rs ) {
			_log "Starting job ". $r->name;
			$r->status('RUNNING');
			$r->update;
			warn "$0 :: @ARGV";
			my $cmd = "perl $0 job.run runner=\"". $r->runner ."\" jobid=". $r->id;
			my $proc = Proc::Background->new( $cmd );
			$r->pid( $proc->pid );
			$r->update;
		}
        $self->job_expired($c);
		sleep $freq;	
	}
}

sub job_expired {
	my ($self,$c)=@_;
    #_log( "Checking for expired jobs..." );
    my $rs = $c->model('Baseliner::BaliJob')->search({ 
			maxstarttime => { '<' , _now }, 
			status => 'READY',
    });
    while( my $row = $rs->next ) {
		_log( "Job $row->{name} expired (maxstartime=" . $row->{maxstarttime});
		$row->status('EXPIRED');
		$row->update;
    }
    $rs = $c->model('Baseliner::BaliJob')->search({ 
			status => 'RUNNING',
    });
    while( my $row = $rs->next ) {
		if( $row->pid ) {
			unless( pexists( $row->pid ) ) {
				_log _loc("Detected killed job %1", $row->name ); 
				$row->status('KILLED');
				$row->update;
			}
		}
    }
    return;
}

1;

