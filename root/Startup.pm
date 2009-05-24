package Baseliner::Startup;

use strict;
use warnings FATAL => 'all';

use MRO::Compat;
use Devel::InnerPackage qw/list_packages/;

## load plugins
require Module::Pluggable; 

sub setup_components {
    my $class = shift;
    $class->next::method(@_);
	warn "CLASS: $class\n";
	__PACKAGE__->load_plugins;
}

sub load_plugins {
	my $self = shift;
	my $loadstatus=1;
	my $search_path = [];
	eval q{ $search_path = Baseliner->config->{PluginNamespace}->{prefix} };
	if( $@ ) {  ## Baseliner is not loaded yet
		$search_path = [ qw/BaselinerX/ ];
	}
	$search_path = [  $search_path ] unless ref $search_path;
	print STDERR "*** Loading search path: ",join',',@{ $search_path },"\n";
	Module::Pluggable->import( 
		search_path => $search_path, 
		require => 1  ## doing a require registers all services, config_sets, etc
	);
	foreach my $plugin ( $self->plugins ) { ## seems to load them
		print "Registering $plugin\n";
		$plugin->begin_services; 
		foreach my $service (  $plugin->services() ) {
			print "- /service/".$service->id()."\n";
		}
		foreach my $cs (  $plugin->config_sets() ) {
			print "- /config/".$cs->id()."\n";
		}
		$plugin->end_services; 
	}; 
}


1;