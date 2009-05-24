package BaselinerX::Type::Service;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

register_class 'service' => __PACKAGE__;

has 'id'=> (is=>'rw', isa=>'Str', default=>'');
has 'name' => ( is=> 'rw', isa=> 'Str' );
has 'desc' => ( is=> 'rw', isa=> 'Str' );
has 'handler' => ( is=> 'rw', isa=> 'CodeRef' );
has 'config' => ( is=> 'rw', isa=> 'Str' );

has 'type' => (is=>'rw', isa=>'Str', default=>'std');
has 'alias' => ( 
	is=> 'rw', isa=> 'Str',
	trigger=> sub {
		my ($self,$alias,$meta)=@_;
		my $alias_key = 'alias.'.$alias;
		register $alias_key => { link => $self->id };
		Baseliner::Plug->registry->initialize($alias_key);
	}
);

sub BUILD {
	my ($self, $params) = @_;
	## handler should always point to some code
	unless( $self->handler ) {
		$self->handler( \&{ $self->module().'::'.$self->id } );
	}
}

sub dispatch {
	my ($self, %p )=@_;
	my $c = $p{app};
	my $config;
	my $config_data;
	if( $self->config ) {
		$config = Baseliner::Core::Registry->get( $self->config ) or die "Could not find config '$self->{config}' for service '$self->{name}'";
	} else {
		warn "Missing config for service '$self->{name}'";
		## service will have to deal with @ARGV by itself
	}

	if( $p{'-cli'} ) {
		## the command line is an overwrite of the usual stash system
		$config_data = $config->getopt;
		#$config_data->{argv} = \@argv_noservice;
		use YAML;
		print "===Config $self->{config}===\n",YAML::Dump($config_data),"\n";
	} 
	elsif( $p{'-ns'} ) {
		$config_data = $config->load_from_ns($p{'-ns'} );
	}
	else {
		$config_data = $config->load_from_ns('/');
	}

	$self->run($c, $config_data);
}

## run module services subs ( service->code or sub module::service )
sub run {
	my $self= shift;
	my $service = $self->id;
	my $key = $self->key;
	my $version = $self->registry_node->version;
	my $handler = $self->handler;
	my $module = $self->module;
	$ENV{CATALYST_DEBUG} && print STDERR "===Config $self->{config}===\n",YAML::Dump(@_),"\n" if( @_);
	print "===Starting service: $key | $version | $service | $module ===\n";
	if( ref($handler) eq 'CODE' ) {
		$handler->( $self, @_ );
	} 
	elsif( $handler && $module ) {
		$module->$handler($self, @_);	
	}
	else {
		die "Can't find sub $service {...} nor a handler directive for the service '$service'";
	}
}

# print usage info for all services
sub usage {
	my $self = shift;
	my $RET="";
	foreach my $service ( keys %{ self->services } ) {
		$RET.= $service."\n";
		if ( ref $self->services->{$service}->{config} ) {
			my $config = $self->services->{$service}->{config};
			my $task = join ' ', map { "-".join '=', split /\|/, $_ } map { $config->{task}{$_}{opt} } keys %{$config->{task}};
			$RET .= "\tbali $service ".$task." ".$config->{cmd}{line}."\n";
			$RET .= "\t".$config->{cmd}{desc}."\n";
		}
		else {
			$RET .= $self->services->{$service}->{usage}."\n";
			$RET .= $self->services->{$service}->{description}."\n";
		}
	}
	$RET =~ s/\n\n/\n/g; ## cleanup
	return $RET;
}

1;
