package BaselinerX::Type::Service::Controller;
use Baseliner::Plug;
BEGIN { extends 'Catalyst::Controller' };

sub list_services : Path('/admin/type/service/list_services') {
	my ($self,$c)=@_;
	use YAML;
	$c->res->body( "<pre>".Dump $c->registry->starts_with( 'service' ) );
}



1;