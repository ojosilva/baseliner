package Baseliner::Plugin;

use Moose::Role;
use Hash::Merge::Simple qw/merge/;

use Baseliner::Core::Registry;
use Baseliner::Core::Service;
use Baseliner::Core::ConfigSet;

## called before loading any services (may be used to dynamically create services)
sub begin_services { }
sub end_services { }

# create a new Service object
# bless it into a global list
sub add_service { 
	my $self=shift;  ## the packagename where this service is defined
	while( @_ ) {
		my $service_name = shift;
		my $service_def  = shift;
		my $obj = Baseliner::Core::Service->new( merge $service_def, { plugin => $self, id=> $service_name } );
		Baseliner::Core::Registry->register( '/service', $service_name, $obj );	
	}
}

## config objs are stored separate from services
sub add_config { 
	my $self=shift;
	while( @_ ) {
		my $config_name = shift;
		my $config_def  = shift;
		my $obj = Baseliner::Core::ConfigSet->new( merge $config_def, { plugin => $self, id=> $config_name } );
		Baseliner::Core::Registry->register( '/config', $config_name, $obj );	
	}
}

## looks for a config file, then for registered __PACKAGE__->services
sub services { 
	my $self=shift; 
	return Baseliner::Core::Registry->search_for('/service', plugin=> $self );
}
sub config_sets { 
	my $self=shift; 
	return Baseliner::Core::Registry->search_for('/config', plugin=> $self );
}

1;

__END__

=head1 DESCRIPTION

Base class for all plugins. 

=head1 OVERRIDES

Every plugin should override:

	sub services { }

