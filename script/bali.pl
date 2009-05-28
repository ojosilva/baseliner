use strict;
use warnings;
use Pod::Usage;
use FindBin;
use lib "$FindBin::Bin/../lib";	
use Hash::Merge::Simple qw/merge/;

require Baseliner;
my $c = Baseliner->commandline;
use YAML;

if( !@ARGV ) {
	print "Baseliner 1.0\n";
	my @serv = $c->registry->starts_with('service');
	print "===Available services===\n", join( "\n", @serv ), "\n";
	#print "===Available services===\n", join( "\n", map { $_ . " - " . ( $serv->{$_}->{name} || "$_ service" ) } keys %$serv );
	exit 0;
}

my @argv = @ARGV;
my $service_name = shift @ARGV;
use Getopt::Long;
GetOptions(
    'ns=s' => \( my $ns = '/' ),
    'bl=s' => \( my $bl = '*' )
);
$c->stash->{ns} = $ns;
$c->stash->{bl} = $bl;

# load data from a stored config record
## ie. bali server --config config://
#GetOptions( 'config' => \$config_data );
#print Baseliner::Plug->registry->dump_yaml;
#print '*' x 100, "\n";
#print Dump Baseliner::Plug->registry->( key=>'service', short_name=>'start_web');

my @argv_noservice = @ARGV;
## get service
my $service = $c->registry->get($service_name) || die "Could not find service '$service_name'";
my $config = $c->registry->get( $service->config ) if( $service->config );
my $config_data;
if( $config ) {
	#$config_data = { %{$config_data||{}}, %{ $config->getopt ||{}} };
	$config_data = $config->factory( $c, ns=>$ns, bl=>$bl, getopt=>1 );
}

## setup context 
#$c->load_stash( $service->config );
#$c->model('BaselinerX::Type::Config')->getopt;
#$c->load_inf( $ns, $service->config, 
#my $b = Baseliner::Loader->new( ns => $ns );
#$b->run( short_name=> $service_name );

$service->run( $c, $config_data );

#if( $service->config ) {
#	my $config = Baseliner::Core::Registry->get( $service->config ) or die "Could not find config '$service->{config}' for service '$service_name'";
#	my $config_data = $config->getopt;
#	$config_data->{argv} = \@argv_noservice;
#	print "===Config $service->{config}===\n",Dump($config_data),"\n";
#	$service->dispatch( $config_data );
#} else {
#	warn "Missing config for service '$service_name'";
#	## service will have to deal with @ARGV by itself
#	$service->dispatch();
#}

#pod2usage(1) if $help;
