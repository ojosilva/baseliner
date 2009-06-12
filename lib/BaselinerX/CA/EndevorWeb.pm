package BaselinerX::CA::EndevorWeb;
use Baseliner::Plug;
use Baseliner::Utils;
BEGIN { extends 'Catalyst::Controller' }
use BaselinerX::CA::Endevor;
use JavaScript::Dumper;

register 'menu.endevor' => { label => 'Endevor' };
register 'menu.endevor.list' =>
  { label => 'List Packages', url_comp => '/endevor/list/pkgs', title=>'ListPackages' };
register 'config.endevor.package' => {
    metadata => [
        { id => 'package',     label => 'Package' },
        { id => 'type',        label => 'Type' },
        { id => 'status',      label => 'Status' },
        { id => 'description', label => 'Description' },
        { id => 'env',         label => 'Target Environment' },
    ],
};
use YAML;

sub list_pkgs_json : Path('/endevor/list/pkgs_json') {
    my ( $self, $c ) = @_;
    my @rows;
    my $query = $c->req->params->{query};
    my $p = $c->cache->get('endevor');
    if( ref $p ) {
        foreach (  keys %{ $p || {} } ) {
            my $str = join ',', values( %{ $p->{$_} || {} } );
            next if( $query && ( $str !~ /$query/i ) );
            my $data = {
                package     => $_,
                type        => $p->{$_}->{PKG_TYPE},
                status      => $p->{$_}->{STATUS},
                description => $p->{$_}->{DESCRIPTION},
                env         => $p->{$_}->{PROM_TGT_ENV}
            };
            push @rows, $data;
        }
    } else {
        $p ||= {};
        eval {
            my $inf = $c->registry->get('config.endevor.connection')->factory($c);
            alarm $inf->{timeout};
            $SIG{ALRM} = sub {
                die _loc "Timeout Error (timeout="
                    . $inf->{timeout}
                . "s) while connected to MVS";
            };
            my $ret;
            my $e = BaselinerX::CA::Endevor->new(
                    host  => $inf->{host},
                    user  => $inf->{user},
                    pw    => $inf->{pw},
                    surr  => $inf->{surr},
                    class => $inf->{class}
                    );
            my %pkgs = $e->pkgs;
            for ( keys %pkgs ) {
                my $str = join ',', values %{ $pkgs{$_} || {} };
                next if( $query && $str !~ /$query/i );
                my $data = {
                    package     => $_,
                    type        => $pkgs{$_}{PKG_TYPE},
                    status      => $pkgs{$_}{STATUS},
                    description => $pkgs{$_}{DESCRIPTION},
                    env         => $pkgs{$_}{PROM_TGT_ENV}
                };
                $p->{$_} = $pkgs{$_};
                push @rows, $data;
            }
            ##(my $rc = $ret)=~ s{^.*\n\s+EXECUTE.*(\Q$package\E\s+)(\d+)\s*.*$}{$2}sg ;   ##s{^.*END OF EXECUTION LOG - HIGHEST ENDEVOR RC =(.*?)\n.*$}{$1}gs;
            #$ret && (my $rc = $ret)=~ s{^.*Highest return code is (\d+).*$}{$1}sg;
            #  join(',',unpack('c*',$rc))
            #$rc && print "\n\nRETURN CODE = [".$rc."]\n";
            alarm;
        };
        if ($@) {
            warn "Timeout Error during list_pkgs_json: $@";
        }
        $c->cache->set('endevor', $p );
    }
    $c->stash->{json} = { cat => \@rows };
    $c->forward('View::JSON');
}

sub pkg_data : Path('/endevor/pkg_data') {
    my ( $self, $c ) = @_;
    my $p = $c->cache->get('endevor');
    my $pkg = $c->req->param("package");
    $c->stash->{data}= $p->{$pkg};
    $c->stash->{package}= $pkg;
    $c->stash->{template}       = '/comp/endevor_pkg.mas';
}

sub list_pkgs : Path('/endevor/list/pkgs') {
    my ( $self, $c ) = @_;
    my $config = $c->registry->get('config.endevor.package');
    $c->stash->{url_store}      = '/endevor/list/pkgs_json';
    $c->stash->{url_add}        = '/endevor/new';
    $c->stash->{url_detail}     = $c->uri_for('/endevor/pkg_data');
    $c->stash->{detail_title}   = 'Package';
    $c->stash->{detail_field}   = 'package';
    $c->stash->{title}          = 'Endevor Packages';
    $c->stash->{columns}        = js_dumper $config->grid_columns;
    $c->stash->{fields}         = js_dumper $config->grid_fields;
    $c->stash->{ordered_fields} = [ $config->column_order ];
    $c->stash->{template}       = '/comp/grid.mas';
}

1;
