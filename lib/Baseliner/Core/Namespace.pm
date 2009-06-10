package Baseliner::Core::Namespace;
use Moose;

has 'ns' => ( is=>'rw', isa=>'Str', required=>1 ); ## the namespace path
has 'ns_name' => ( is=>'rw', isa=>'Str', required=>1 ); ## the namespace name token
has 'ns_type' => ( is=>'rw', isa=>'Str', required=>1 ); ## a text that represents the namespace
has 'ns_id' => ( is=>'rw', isa=>'Any' );  ## the namespace provider's internal id
has 'ns_info' => ( is=>'rw', isa=>'Any' );  ## array of info to present the user
has 'ns_data' => ( is=>'rw', isa=>'Any' );  ## free data store for the provider
has 'ns_parent' => ( is=>'rw', isa=>'Any' );  ## parent ns
has 'can_job' => ( is=>'rw', isa=>'Bool', default=>0 );  ## can it be listed for jobs?
has 'icon' => ( is=>'rw', isa=>'Str' );  ## icon path or css to represent ns
has 'user' => ( is=>'rw', isa=>'Str', default=>'-' ); 
has 'date' => ( is=>'rw', isa=>'Str', );  ## object last modified date

no Moose;

sub ns_text {
	my $self = shift;
	return $self->ns_type if( $self->ns eq '/');
	return $self->ns_name . " (" . $self->ns_type . ")";
}

## ----- static methods

use Baseliner::Core::Registry;
sub namespaces {
	my $self = shift; 
	my $p = shift || {};
	my @ns_list;
	my @ns_prov_list = Baseliner::Core::Registry->starts_with('namespace');
	for my $ns_prov ( @ns_prov_list ) {
		my $prov = Baseliner::Core::Registry->get( $ns_prov );
		next if( $p->{can_job} && !$prov->can_job );
		my $prov_list = $prov->handler->($prov, $p);
		push @ns_list, @{  $prov_list || [] };
	}
	return sort { $a->ns cmp $b->ns } @ns_list;
}

sub namespaces_hash {
	my $self = shift; 
	my @ns_list = $self->namespaces;
	my %h;
	for( @ns_list ) {
		$h{ $_->ns } = $_;
	}
	return %h;
}

sub find_text {
	my $self = shift; 
	my $ns = shift; 
	my %h = $self->namespaces_hash;
	my $p = $h{ $ns };
	if( $p ) {
		return $p->ns_text;
	} else {
		return _loc('Namespace') . " $ns";	
	}
}

1;
