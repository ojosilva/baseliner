package Baseliner::Core::Registrable;
use Moose::Role;

has 'key' => (is=>'rw', isa=>'Any', default=>'' );
has 'module' => (is=>'rw', isa=>'Str', required=>1 );
has 'version' => (is=>'rw', isa=>'Str', default=>'0.1', required=>1 );
has 'registry_node' => (is=>'rw', isa=>'Object' , required=>1, weak_ref=>1 );

sub registry {
	return 'Baseliner::Core::Registry';
}
	
sub short_from_key {
	my ($self, $key ) =@_;
	(my $var = $key) =~ s{^(.*)\.(.*?)$}{$2}g;
	return $var;
}

sub get_children {
	my ($self) = @_;
	my @current_depth = split(/\./, "" .$self->{key}) ;
	my $current_depth = @current_depth - 1 ;
	return $self->registry->search_for( key => $self->{key} . '.' , depth => $current_depth + 1);
}

1;
