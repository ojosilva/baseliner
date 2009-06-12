package BaselinerX::Server;
use Baseliner::Plug;

register 'config.server.web' => {
		name => 'Web Server Settings',
		metadata => [
			{ id=> 'host', label=> 'Web Server Host', type=> 'text' },
			{ id=> 'debug', opt=> 'debug|d', label=> 'Debug Mode', type=> 'bool' },
			{ id=> 'port', opt=> 'port|p', label=> 'Web Server Port', type=> 'text', default => $ENV{BASELINER_PORT} || $ENV{CATALYST_PORT} || 3000 },
			{ id=> 'restart', label=> 'Restartable?', type=> 'bool', default => 0 },
			{ id=> 'restart_delay', type=> 'num', default=> 1, needs=> 'restart' },
			{ id=> 'keepalive', type=> 'bool', default=> 0 },
			{ id=> 'restart_directory', type=> 'text', default=> '' },
			{ id=> 'follow_symlinks', type=> 'bool', default=> 1 },
			{ id=> 'fork', type=> 'bool', default=> 0 },
			{ id=> 'restart_regex', type=> 'text', default=> '(?:/|^)(?!\.#).+(?:\.yml$|\.yaml$|\.conf|\.pm)$' },
		]
};

register 'service.scheduler' => {
		name => 'Scheduler Settings',
		handler=>sub{},
		metadata => [
			{ id=> 'frequency', label=> 'Check Frequency', type=> 'num' },
		]
};

register 'service.start_web' => { 
		name	=> 'Web Server Start',
		alias	=> 'start_web',
		type	=> 'pre',
		desc	=> 'Start the Catalyst Web Server',
		config	=> 'config.server.web',
};

# Controller
BEGIN { extends 'Catalyst::Controller' };

sub web_status : Path('admin/web_status') {
	my ($self,$c)=@_;
	use YAML;
	$c->res->body( YAML::Dump $self );
}
sub stop_server : Local {
	my ($self,$c)=@_;
	$c->stash->{template} = 'comp/message.tt';
	$c->stash->{message} = "Web Server shuting down now: " . localtime();
	$c->forward( $c->view('TT') );
	$c->finalize_body;
	#$self->graceful_shutdown();
}

sub graceful_shutdown {
	my ($self)=@_;
	warn "Shutting down gracefully";
	for(1..3) {
		warn( "Shutting down in " . ( 3 - $_ ) );
		sleep(1);
	}
	warn "Shutdown";
	exit(0);
}

sub start_web {
	my ($class, $c, $conf) = @_;
    $ENV{CATALYST_ENGINE} ||= 'HTTP';
    $ENV{CATALYST_SCRIPT_GEN} = 31;
    require Catalyst::Engine::HTTP;

	if ( $conf->{restart} && $ENV{CATALYST_ENGINE} eq 'HTTP' ) {
		$ENV{CATALYST_ENGINE} = 'HTTP::Restarter';
	}
	if ( $conf->{debug} ) {
		$ENV{CATALYST_DEBUG} = 1;
	} else {
		$ENV{CATALYST_DEBUG} = 0;
	}

	#require Baseliner; ## just in case
	Baseliner->setup_engine( $ENV{CATALYST_ENGINE} );
	#print "ARGV" . join(',',@{ $conf->{argv} })."\n";
	#no warnings;
	Baseliner->run( 
		$conf->{port},
		$conf->{host},
		{
			argv => $conf->{argv},
		    'fork' => $conf->{'fork'},
			keepalive         => $conf->{keepalive},
			restart           => $conf->{restart},
			restart_delay     => $conf->{restart_delay},
			restart_regex     => qr/$conf->{restart_regex}/,
			restart_directory => $conf->{restart_directory},
			follow_symlinks   => $conf->{follow_symlinks},			
		}
	);
}

1;
