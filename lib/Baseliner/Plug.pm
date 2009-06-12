package Baseliner::Plug;

=head1 DESCRIPTION

Sugar for registrable plugins.

=cut

use strict;
use warnings;
use Baseliner::Core::Registry;
use Package::Alias Registry => 'Baseliner::Core::Registry';

use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods( 
	with_caller => [ 'register','register_class' ],
	also => [ 'Moose' ]
);

sub register {
	my $package = shift;
	my $key = shift;
	my $obj = shift;
	Baseliner::Core::Registry->add( $package, $key, $obj);
}

sub register_class {
	my $package = shift;
	my $key = shift;
	my $obj = shift;
	Baseliner::Core::Registry->add_class( $package, $key, $obj);
}

sub registry {
	return 'Baseliner::Core::Registry';
}

1;
