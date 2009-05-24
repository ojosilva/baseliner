package BaselinerX::Prueba;
use Baseliner::Plug;

BEGIN { extends 'Catalyst::Controller' }

register 'menu.prueba' => {  label=>'Prueba', url=>'/prueba/hola' };

register 'config.prueba' => {
    metadata => [
        { id=>'edad', label=>'Tu Edad', default=>99, width=>200,  }
    ]

};
register 'service.prueba' => {
    name => 'Una prueba',
    config => 'config.prueba',

};
sub prueba {
        my ($self,$c,$config)=@_;
        print "Hooola. Tu edadd=" . $config->{edad};
}
sub prueba1 : Path('/prueba/hola') {
    my ($self,  $c)=@_;
    #$c->stash->{title} = 'Tituto';
    #$c->stash->{template} = '/comp/grid.mas';
    $c->res->body(   Dump $c->req->params );
}

1;
