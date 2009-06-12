package Baseliner::Core::Registry;

use Moose;
use MooseX::ClassAttribute;
use Moose::Exporter;
Moose::Exporter->setup_import_methods();
use Carp;
use YAML;

class_has 'registrar' =>
	( is      => 'rw',
	  isa     => 'HashRef',
	  default => sub { {} },
	);

class_has 'classes' =>
	( is      => 'rw',
	  isa     => 'HashRef',
	  default => sub { {} },
	);

{
	package Baseliner::Core::RegistryNode;
	use Moose;

	has 'key'=> (is=>'rw', isa=>'Str', required=>1 );
	has 'id'=> (is=>'rw', isa=>'Str', required=>1 );
	has 'module' => (is=>'rw', isa=>'Str', required=>1 );
	has 'version' => (is=>'rw', isa=>'Str', default=>'1.0');
	has 'init_rc' => (is=>'rw', isa=>'Int', default=> 5 );
	has 'param' => (is=>'rw', isa=>'HashRef', default=>sub{{}} );
	has 'instance'=> (is=>'rw', isa=>'Object' );
	
}	

sub add {
	my ($self, $pkg, $key, $param)=@_;
	my $reg = $self->registrar();
	$param->{key}=$key unless($param->{key});
	$param->{short_name} = $key; 
	$param->{short_name} =~ s{^.*\.(.+?)$}{$1}g if( $key =~ /\./ );
	$param->{id}= $param->{id} || $param->{short_name};
	$param->{module}=$pkg unless($param->{module});
	
	my $node = Baseliner::Core::RegistryNode->new( $param );
	$node->param( $param );
	$node->param->{registry_node} = $node;
	$reg->{$key} = $node;
}

sub add_class {
	my ($self, $pkg, $key, $class)=@_;
	my $reg = $self->classes();
	$reg->{$key} = $class;
}

## blesses all registered objects into their registrable classes (new Service, new Config, etc.)
sub initialize {
	my $self= shift; 
	my @namespaces = ( @_ ? @_ : keys %{ $self->registrar || {} } );
	my %init_rc = ();
	## order by init_rc
	for my $key ( @namespaces ) {
		my $node = $self->registrar->{$key};
		next if( ref $node->instance );  ## already initialized
		push @{ $init_rc{ $node->init_rc } } , [ $key, $node ];
	}
	## now, startup ordered based on init_rc
	## TODO: solve dependencies with a graph
	for my $rc ( sort keys %init_rc ) {
		for my $rc_node ( sort @{ $init_rc{$rc} } ) {
			my ($key, $node) = @{  $rc_node };
			## search for my class backwards	
			$self->instantiate( $node );
		}
	}
}

## bless an object instance with the provided params
sub instantiate {
	my ($self,$node,$class)=@_;	
	$class ||= $self->_find_class( $node->key );
	$node->{instance} = $class->new( $node->param );
}

## find the corresponding class for a component
sub _find_class {
	my ($self,$key)=@_;
	my $class = $key;
	my $node = $self->get_node($key);
	my @domain = split /\./, $key;
	for( my $i=$#domain; $i>=0; $i-- ) {
		$class = join '.',@domain[ 0..$i ];
		last if( $self->classes->{$class} ) ;
	}
	my $class_module = $self->classes->{$class} || $node->module; ## if no class found, bless onto itself
		#'BaselinerX::Type::Generic';  ## if no class found, assign it to generic
	$ENV{CATALYST_DEBUG} && print STDERR "\t\t*** CLASS: $class ($class_module) FOR $key\n";
	return $class_module;
}

## return the key registration object (node)
sub get_node {
	my ($self,$key)=@_;
	$key || confess "Missing parameter \$key";
	return ( $self->registrar->{$key} 
		or $self->search_for_node( id=>$key ) 
        or $self->get_partial($key) );
}

## return a registered object
sub get { return $_[0]->get_instance($_[1]); }

sub get_instance {
	my ($self,$key)=@_;
	my $node = $self->get_node($key) || die "Could not find key '$key' in the registry";
	my $obj = $node->instance;
	return ( ref $obj ? $obj : $self->instantiate( $node ) );
}

sub get_partial {
	my ($self,$key)=@_;
    my @found = map { $self->registrar->{$_} } grep /$key$/, keys %{ $self->registrar || {} };
    return wantarray ? @found : $found[0];
}

sub dir {
	my ($self,$key)=@_;
	return keys %{ $self->registrar || {} }
}

sub dump_yaml {
	use YAML;
	Dump( shift->registrar );
}

## search for registered objs with matching attributes
sub search_for_node {
	my ($self,%query)=@_;
	my @found = ();
	my $key_prefix = delete $query{key} || '';
	my $q_depth = delete $query{depth};
	$q_depth||= 99; 
	OUTER: for my $key ( $self->starts_with( $key_prefix ) ) {
		my $depth = ( my @ss = split /\./,$key ) -1 ;
		next if( $depth gt $q_depth );
		foreach my $attr( keys %query ) {
			my $val = $query{$attr};	
			#warn "COMP=$val, ". $self->registrar->{$key}->{$attr} ;
			next OUTER unless( $self->registrar->{$key}->{$attr} eq $val);
		}
		push(@found,$self->registrar->{$key}) ;
	}
	return wantarray ? @found : $found[0];
}

sub search_for {
	my $self=shift;
	my @found_nodes = $self->search_for_node( @_ );
	return map { $_->instance } @found_nodes;
}

sub starts_with {
	my ($self, $key_prefix )=@_;
	my @keys;
	for( keys %{ $self->registrar || {} } ) {
		push @keys, $_ if( /^$key_prefix/ );
	}
	return @keys;
}

sub get_all {
	my ($self, $key_prefix )=@_;
	my @ret;
	#warn "GETALL=$key_prefix";
	for( keys %{ $self->registrar || {} } ) {
		push @ret, $self->get($_) if( /^\Q$key_prefix/ );
	}
	return @ret;
}

1;
