package Baseliner;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/StackTrace
                ConfigLoader 
                CommandLine
				Authentication
				Email
				Cache::FastMmap
				Session		Session::Store::File	Session::State::Cookie
				Singleton           
                I18N
                Static::Simple/;
our $VERSION = '0.01';
#+CatalystX::ListFramework::Builder
__PACKAGE__->config( name => 'Baseliner', default_view => 'Mason' );
__PACKAGE__->config( setup_components => { search_extra => [ 'BaselinerX' ] } );
__PACKAGE__->config->{static}->{dirs} = [
        'static',
        qr/images/,
    ];
__PACKAGE__->config->{static}->{ignore_extensions} 
        = [ qw/mas html js json css/ ];    
__PACKAGE__->config({ 
      'View::JSON' => {
          expose_stash    => 'json',
      },
  });

use Cache::FastMmap;
{
	no warnings;
	no strict;
	sub Cache::FastMmap::CLONE {} ## to avoid the no threads die 
}
__PACKAGE__->config->{cache}->{storage} = 'bali_cache';
__PACKAGE__->config->{cache}->{expires} = 333600;
#__PACKAGE__->config->{authentication}{dbic} = {
#    user_class     => 'Bali::BaliUser',
#    user_field     => 'username',
#    password_field => 'password'
#};

use FindBin '$Bin';
#$c->languages( ['es'] );
__PACKAGE__->config(
	'Plugin::I18N' =>
		maketext_options => {
			Style => 'gettext',
			Path => $Bin.'/../lib/Baseliner/I18N',
		}
);

# Start the application
__PACKAGE__->setup();

# Setup date formating for Oracle
my $dbh = __PACKAGE__->model('Baseliner')->storage->dbh;
if( $dbh->{Driver}->{Name} eq 'Oracle' ) {
	$dbh->do("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'");
	$dbh->{LongReadLen} = 2147483647;
}
	
	# Inversion of Control
	use Baseliner::Core::Registry;
	Baseliner::Core::Registry->initialize;

	# Make registry easily available to contexts
	sub registry {
		my $c = shift;
		return 'Baseliner::Core::Registry';
	}

	sub c {
		__PACKAGE__->commandline;
	}
	
	sub launch {
		my ($c, $service_name, $ns, $bl ) = @_;
		$ns ||='/';
		$bl ||='*';
		my $service = $c->registry->get($service_name) || die "Could not find service '$service_name'";
		my $config = $c->registry->get( $service->config ) if( $service->config );
		my $config_data;
		if( $config ) {
			$config_data = $config->factory( $c, ns=>$ns, bl=>$bl, getopt=>1 );
		}
		$service->run( $c, $config_data );
	}

	sub inf {
		my $c = shift;
		my %p = @_;
		$p{ns} ||= '/';
		$p{bl} ||= '*';
		if( $p{domain} ) {
			$p{domain} =~ s{\.$}{}g;
			$p{key}={ -like => "$p{domain}.%" };
		}
		print "KEY==$p{domain}\n";
		my %data;
		my $rs = $c->model('Baseliner::Bigtable')->search({ ns=>$p{ns}, bl=>$p{bl}, key=>$p{key} });
		while( my $r = $rs->next  ) {
			(my $var = $r->key) =~ s{^(.*)\.(.*?)$}{$2}g;
			$c->stash->{$var} = $r->value;
			$data{$var} = $r->value;
		}
		return \%data;
	}
	sub inf_bl {
		my $c=shift;
		$c->stash->{bl};
	}
	sub inf_search {
		my ($c, %p ) = @_;
		$p{ns} ||= '%';
		$p{bl} ||= '%';
		$p{key} ||= '%';
		my $bl = $p{bl} eq '*' ? '%' : $p{bl};
		my $ns = $p{ns} ? $p{ns}.'/%' : '%';
		$ns =~ s{//}{/}g;
		warn "------------SEARCH: $ns,$bl,$p{key}"; 
		return $c->model('Baseliner::Bigtable')->search({ ns=>{ -like => $ns },bl=>{ -like =>$bl },key=>{ -like =>$p{key} }}); 
	}
	sub inf_write {
		my ($c,%p) = @_;
		$p{ns} ||= '/';
		$p{bl} ||= '*';
		$c->model('Baseliner::Bigtable')->create({ ns=>$p{ns},bl=>$p{bl}, key=>$p{key}, value=>$p{value} }); 
	}

# Utils
sub uri_for_static {
    my ( $self, $asset ) = @_;
    return ( $self->config->{static_path} || '/static/' ) . $asset;
}

=head1 NAME

Baseliner - Catalyst based application

=head1 SYNOPSIS

    script/baseliner_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Baseliner::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
