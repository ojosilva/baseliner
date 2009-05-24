use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

require Baseliner;
if( !@ARGV ) {

	print "Baseliner 1.0\n";
	my $serv = Baseliner::Core::Registry->Services ;
	print "===Available services===\n", join( "\n", map { $_ . " - " . ( $serv->{$_}->{name} || "$_ service" ) } keys %$serv );
	exit 0;
} 


my @argv = @ARGV;
my $service_name = shift @ARGV;
my $ns = '/';
my $c = Baseliner->commandline;
use Data::Dumper;
print "MODEL:" . Dumper $c->model('Baseliner');
#$c->model('Service')->launch($service_name);
#$c->stash->{host} = 'sysb';
#$c->inf;

##$c->comp( 'Baseliner::Model::Launcher' )->launch($c);

#$c->forward( 'Test::Model::Foo', 'foo'  );
#$c->launch( 'foo' );