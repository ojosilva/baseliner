package BaselinerX::Core;
use Baseliner::Plug;

register 'menu.admin' => { label => 'Admin' };
register 'menu.admin.registry' => { label => 'List Registry Data', url=>'/core/registry', title=>'Registry' };

BEGIN { extends 'Catalyst::Controller' }
use YAML;
sub registry : Path('/core/registry') {
    my ( $self, $c ) = @_;
	$c->res->body( '<pre>' . YAML::Dump( $c->registry->registrar ) );
}
1;


