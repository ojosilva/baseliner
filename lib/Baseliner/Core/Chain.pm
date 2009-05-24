package Baseliner::Core::Chain;
use Moose;

#has 'stash' => (is=>'rw', isa=>'HashRef', default=>sub {{}} );
#has 'path' => (is=>'rw', isa=>'ArrayRef', default=>{[]} );

# loads the stash object with data from the registry metadata
sub load {
	my $self=shift;
}

sub run {
	my ($self,%p)=@_;	
	
}

1;
