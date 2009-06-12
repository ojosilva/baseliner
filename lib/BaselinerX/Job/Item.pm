package BaselinerX::Job::Item;
use Moose;

{ id=>'1', provider=>'Harvest Packages', item=>'H0001S1010@01', ns=>'/apl/G0001', user=>'ROG2833Z', text=>'Paquete 1.', date=>'2009-10-01' },

has 'provider' => ( is=>'rw', isa=>'Str', required=>1 );  ## namespace provider
has 'type' => ( is=>'rw', isa=>'Str', required=>1 );  ## 'Release', etc..
has 'item' => ( is=>'rw', isa=>'Str', required=>1 );  ## short name for the namespace
#has 'ns' => ( is=>'rw', isa=>'Str', required=>1 ); ## the namespace path
has 'user' => ( is=>'rw', isa=>'Str', default=>'-' ); 
has 'text' => ( is=>'rw', isa=>'Str', required=>1 ); ## long description, comments, etc.
has 'date' => ( is=>'rw', isa=>'Str', required=>1 );  ## object last modified date


sub id {
	my $self = shift;
}

1;
