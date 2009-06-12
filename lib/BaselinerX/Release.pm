package BaselinerX::Release;
use Baseliner::Plug;
use Baseliner::Utils;
use DateTime;
use YAML;
use Carp;

BEGIN { extends 'Catalyst::Controller' }
BEGIN { 
    ## Oracle needs this
    $ENV{'NLS_DATE_FORMAT'} = 'YYYY-MM-DD HH24:MI:SS';
}
use JavaScript::Dumper;

register 'config.release' => {
	metadata=> [
		{ id=>'jobid', label => 'Job ID', type=>'text', width=>200 },
		{ id=>'name', label => 'Job Name', type=>'text', width=>180 },
		{ id=>'starttime', label => 'StartDate', type=>'text', },
		{ id=>'maxstarttime', label => 'MaxStartDate', type=>'text', },
		{ id=>'endtime', label => 'EndDate', type=>'text' },
		{ id=>'status', label => 'Status', type=>'text', default=>'READY' },
		{ id=>'mask', label => 'Job Naming Mask', type=>'text', default=>'%s.%s-%08d' },
		{ id=>'runner', label => 'Registry Entry to run', type=>'text', default=>'service.job.dummy' },
		{ id=>'comment', label => 'Comment', type=>'text' },
	],
};

register 'menu.release' => { label => _loc('Releases') };
register 'menu.release.new' => { label => _loc('Create a new Release'), url=>'/release/new', title=>_loc('New Release') };
register 'menu.release.list' => { label => _loc('List Releases'), url_comp => '/release/list', title=>_loc('Releases') };

sub release_contents :Private {
    my ( $self, $c ) = @_;
	my $id_rel = $c->stash->{id};
	my $rs = $c->model('Baseliner::BaliReleaseItems')->search({ id_rel=> $id_rel });
	my @rows;
	my @items;
	while( my $r = $rs->next ) {
		push @items, $r->item . " (" . $r->provider . ")";
		push @rows, { id=>$r->id, item=>$r->item, provider=>$r->provider, data=>$r->data  };
	}
	$c->stash->{item_list} = \@items;
	$c->stash->{contents} =  \@rows;
}

sub release_new : Path('/release/new')  {
    my ( $self, $c ) = @_;
	$c->forward('/namespace/load_namespaces');
	$c->forward('/baseline/load_baselines_no_root');
    $c->stash->{template} = '/comp/release_form.mas';
}

sub release_edit : Path('/release/edit')  {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	my $id_rel = $p->{id_rel};
	my $row = $c->model('Baseliner::BaliRelease')->search({ id=> $id_rel })->first;
	if( $row ) {
		$c->stash->{id} = $id_rel;
		$c->stash->{name} = $row->name;
		$c->stash->{bl} = $row->bl;
		$c->stash->{description} = $row->description;
	}
	$c->forward('/namespace/load_namespaces');
	$c->forward('/baseline/load_baselines_no_root');
    $c->stash->{template} = '/comp/release_form.mas';
}

sub release_items_json : Path('/release/items/json') {
    my ( $self, $c ) = @_;
	$c->req->params->{job_type} = 'promote';
	$c->detach('/job_items_json');
}

sub release_contents_json : Path('/release/contents/json') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	$c->stash->{id} = $p->{id};
	$c->forward('/release_contents');
	$c->stash->{json} = { 
		totalCount => scalar @{$c->stash->{contents}},
		data => $c->stash->{contents}
	};
	$c->forward('View::JSON');
}

sub release_list : Path('/release/list') {
    my ( $self, $c ) = @_;
	$c->stash->{template} = '/comp/release_grid.mas';
}

sub release_json : Path('/release/list/json') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
	my $rs = $c->model('Baseliner::BaliRelease')->search();
	my @rows;
	while( my $r = $rs->next ) {
		$c->stash->{id} = $r->id;
		$c->forward('/release_contents');
		push @rows, { id=>$r->id, name=>$r->name, bl=>$r->bl, description=>$r->description, contents=>'<li>'.join('<li>', @{ $c->stash->{item_list} || [] }) };
	}
	$c->stash->{json} = { 
		totalCount => scalar @rows,
		data => \@rows
	};	
	$c->forward('View::JSON');
}


use JSON::XS;
sub release_update : Path('/release/update') {
    my ( $self, $c ) = @_;
	my $p = $c->request->parameters;
    my $action = $p->{action};
	my $config = $c->registry->get('config.release')->data;
	my $release_name = $p->{release_name};
	eval {
        if( $action eq 'delete' ) {
            my $release = $c->model('Baseliner::Balirelease')->search({ id=> $p->{id_rel} })->first;
            $release->delete;
        }
        else {
            # check if release exists
            unless( $p->{id_rel} ) {
                my $other = $c->model('Baseliner::BaliRelease')->search({ name=>$release_name });
                if( $other->first ) {
                    die _loc("Release Name '%1' already exists.",$release_name); 
                }
            }
            my $bl = $p->{bl};
            my $comments = $p->{comments};
            my $contents = decode_json $p->{release_contents};
            die _loc('No release contents') if( !$contents );
            my $release;
            if( $p->{id_rel} ) {
                $release = $c->model('Baseliner::Balirelease')->search({ id=> $p->{id_rel} })->first;
                if( $release ) {
                    $release->name( $release_name );
                    $release->bl( $bl );
                    $release->description( $comments );
                }
                # delete all old items
                my $rs = $c->model('Baseliner::BaliReleaseItems')->search({ id_rel=>$p->{id_rel} });
                for( $rs->next ) {
                    $_->delete;
                }
                
            } else {
                $release = $c->model('Baseliner::Balirelease')->create({
                        name         => $release_name,
                        bl           => $bl,
                        description  => $comments,
                        active 	     => 1,
                });
            }
            # create release items
            for my $item ( @{ $contents || [] } ) {
                my $items = $c->model('Baseliner::BaliReleaseItems')->create({
                    data => YAML::Dump($item->{data}),
                    item => $item->{item},
                    provider => $item->{provider}, 
                    id_rel => $release->id,
                });
            }
        }
	};
	if( $@ ) {
        warn $@;
		$c->stash->{json} = { success => \0, msg => _loc("Error creating the release: ").$@ };
	} else {
		$c->stash->{json} = { success => \1, msg => _loc("Release %1 created.", $release_name) };
	}
	$c->forward('View::JSON');	
}
1;
