package Baseliner::Core::Baseline;
use Baseliner::Plug;
use Baseliner::Utils;

# not being used:
has 'bl' => ( is=>'rw', isa=>'Str', required=>1 ); 
has 'bl_name' => ( is=>'rw', isa=>'Str', required=>1 ); 
has 'bl_type' => ( is=>'rw', isa=>'Str', required=>1 ); 

no Moose;
## ----- static methods

register 'config.baseline' => {
	name => _loc('Config global baselines'),
	array => 1,
	metadata => [
		{ id=>'id', label=>_loc('Baseline Identifier'), },
		{ id=>'name', label=>_loc('Baseline Name'), },
	],
};

sub name {
	my $self = shift; 
	my $r = Baseliner->model('Baseliner::BaliBaseline')->search({ bl=> shift })->first;
	return $r->name;
}

sub baselines {
	my $self = shift; 
	my $rs = Baseliner->model('Baseliner::BaliBaseline')->search({}, { -asc => 'id' });
	my @bls; 
	while( my $r=$rs->next ) {
		push @bls, { bl=>$r->bl, name=>$r->name }; 	
	}
	return @bls;
}

sub baselines_no_root {
	my $self = shift;
	my @arr = $self->baselines();
	shift @arr if $arr[0]->{bl} eq '*';
	return @arr;
}
1;

