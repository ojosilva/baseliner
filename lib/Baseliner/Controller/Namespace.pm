package Baseliner::Controller::Namespace;
use Baseliner::Plug;
use Baseliner::Utils;
BEGIN {  extends 'Catalyst::Controller' }
use YAML;

register 'menu.admin.ns' => { label => _loc('List all Namespaces'), url=>'/core/namespaces', title=>_loc('Namespaces')  };

sub load_namespaces : Private {
	my ($self,$c)=@_;
	my @ns_arr = ();
	my @ns_list = Baseliner::Core::Namespace->namespaces();
	foreach my $n ( @ns_list ) {
		my $arr = [ $n->ns, $n->ns_text ];
		push @ns_arr, $arr;
	}
	$c->stash->{namespaces} = \@ns_arr;
}

sub ns_list : Path('/core/namespaces') {
	my ($self,$c)=@_;
	my @ns_list = Baseliner::Core::Namespace->namespaces();
	my $res='<pre>';
	for my $n ( @ns_list ) {
		$res.= Dump $n
	}
	$c->res->body($res);
}


1;

