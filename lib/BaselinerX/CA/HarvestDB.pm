package BaselinerX::CA::HarvestDB;
use Baseliner::Plug;
use Baseliner::Core::Namespace;
use Baseliner::Utils;

my $dbh = Baseliner->model('Harvest')->storage->dbh;
if( $dbh->{Driver}->{Name} eq 'Oracle' ) {
	$dbh->do("alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'");
}

register 'config.harvest.db' => {
	metadata => [
		{ id=>'connection', label=>'Connection String', type=>'text' },
		{ id=>'username', label=>'User', type=>'text' },
		{ id=>'password', label=>'Password', type=>'text' },
	]
};

## check if package is approved, merged, etc so it can get into a job or not
sub package_check_status {
	my $p = shift;  ## bl for job, etc.
	my $pkg = shift;  ## data record
	return { can_job=>1, why_not=>'' };
}

our %from_states = ( 
	DES => {  promote => [ 'Desarrollo', 'Desarrollo Integrado' ], demote => 0 },
	PRE => {  promote => [ 'Desarrollo Integrado' ], demote => [ 'Pruebas Integradas', 'Pruebas de Acceptación', 'Pruebas Sistemas' ] },
	PRO => {  promote => [ 'Pruebas Sistemas' ], demote => [ 'Producción' ] },
);

sub state_for_job {
	my $p = shift;
	my $env = $from_states{ $p->{bl} };
	my $states = $env->{ $p->{job_type} };	
	unless( ref $states ) {
		return;
	} else {
		return $states;
	}
}

register 'namespace.harvest.package' => {
	name	=>_loc('Harvest Packages'),
	root    => '/package',
	can_job => 1,
	handler => sub {
		my ($self, $p) = @_;
		my $bl = $p->{bl};
		my $job_type = $p->{job_type};
		my $query = $p->{query};
		my $sql_query;
		if( $p->{can_job} ) {
			my $states = state_for_job({ bl=> $bl, job_type=>$job_type });
			$sql_query = { packageobjid => { '>', 0 }, statename => $states };
		}
		elsif( $p->{states} ) {
			$sql_query = { packageobjid => { '>', 0 }, statename => $p->{states} };
		}
		else {
			$sql_query = { packageobjid => { '>', 0 } };
		}
        my $rs = Baseliner->model('Harvest::Harpackage')->search( $sql_query,{ join => [ 'state','modifier' ] });
		my @ns;
		while( my $r = $rs->next ) {
			( my $pkg_short = lc( $r->packagename ) )=~ s/\s/_/g;
			my $status = package_check_status($p, $r );
			my $info = _loc('State').': '.$r->state->statename."<br>" . _loc('Project').': '.$r->envobjid->environmentname."<br>" ;
			next if( $query && !query_array($query, $r->packagename, $r->modifier->username, $r->state->statename ));
            push @ns, Baseliner::Core::Namespace->new({
                ns      => '/package/' . $pkg_short,
                ns_name => $r->get_column('packagename'),
				ns_info => $info,
				user    => $r->modifier->username,
				date    => $r->get_column('modifiedtime'),
				icon    => '/static/images/scm/package.gif',
				can_job => $status->{can_job}, 
				why_not => $status->{why_not},
				ns_type => _loc('Harvest Package'),
				ns_id   => $r->packageobjid,
				ns_data => { $r->get_columns },
			});
		}
		return \@ns;
	},
};

register 'namespace.harvest.project' => {
	name	=>_loc('Harvest Projects'),
	root    => '/apl',
	handler => sub {
		my $rs = Baseliner->model('Harvest::Harenvironment')->search({ envobjid=>{ '>', '0'}, envisactive=>'Y' });
		my @ns;
		while( my $r = $rs->next ) {
			( my $env_short = lc( $r->environmentname ) )=~ s/\s/_/g;
            push @ns, Baseliner::Core::Namespace->new({
                ns      => '/apl/' . $env_short,
                ns_name => $env_short,
				ns_type => _loc('Harvest Project'),
				ns_id   => $r->envobjid,
				ns_data => { $r->get_columns },
			});
		}
		return \@ns;
	},
};

register 'service.harvest.env_for_item' => {
	name => 'List Environments for Items',
	handler => \&envs_for_item,
};

use YAML;
sub envs_for_item {
	my $iid = shift;
	return () unless $iid;
	my $item  = Baseliner->model('Harvest::Haritems')->search({ itemobjid=>$iid })->first;
	my $rid = $item->repositobjid;
	my $rep  = Baseliner->model('Harvest::Harrepository')->search({ repositobjid=>$rid })->first;
	my $rv = $rep->harrepinviews;
	my %envs;
	while( my $v = $rv->next ) {
		my $env = { $v->viewobjid->envobjid->get_columns };
		next if $env->{envobjid} eq 0;
		next if $envs{ $env->{envobjid} };
		$envs{ $env->{envobjid} } = $env;
	}
	return values %envs;
}

register 'config.harvest.subapl' => {
	metadata => [
		{ id=>'position', label=>_loc('Subapplication position within view path'), default=>3 },
	],
};

register 'config.harvest.nature' => {
	metadata => [
		{ id=>'position', label=>_loc('Nature position within view path'), default=>2 },
	],
};

register 'namespace.harvest.subapl' => {
	name	=>_loc('Harvest Subapplication'),
	root    => '/apl',
	mask    => '/apl/%/subapl',
	handler => sub {
		my $rs = Baseliner->model('Harvest::Harpathfullname')->search({  });
		my @ns;
		my $config = Baseliner->registry->get('config.harvest.subapl')->data;
		my $cnt = $config->{position};
		while( my $r = $rs->next ) {
			my $path = $r->pathfullname;
			my @parts = split /\\/, $path;
			next unless @parts == ($cnt+1); ## the preceding \ counts as the first item
			my $subapl = $parts[$cnt];
			my @envs = envs_for_item( $r->itemobjid->itemobjid );
			for my $env ( @envs ) {
				( my $env_short = lc( $env->{environmentname} ) )=~ s/\s/_/g;
				push @ns, Baseliner::Core::Namespace->new({
					ns      => '/subapl/' . $subapl,
					ns_name => $subapl,
					ns_type => _loc('Harvest Subapplication'),
					ns_id   => $env->{envobjid},
					ns_parent => '/apl/' . $env_short,
					ns_data => { $r->get_columns },
				});
			}
		}
		return \@ns;
	},
};

register 'namespace.harvest.nature' => {
	name	=>_loc('Harvest Nature'),
	root    => '/nature',
	mask    => '',
	handler => sub {
		my $rs = Baseliner->model('Harvest::Harpathfullname')->search({  });
		my @ns;
		my $config = Baseliner->registry->get('config.harvest.nature')->data;
		my $cnt = $config->{position};
		my %done;
		while( my $r = $rs->next ) {
			my $path = $r->pathfullname;
			my @parts = split /\\/, $path;
			next unless @parts == ($cnt+1); ## the preceding \ counts as the first item
			my $nature = $parts[$cnt];
			next if $done{ $nature };
			$done{ $nature } =1;
			push @ns, Baseliner::Core::Namespace->new({
				ns      => '/nature/' . $nature,
				ns_name => $nature,
				ns_type => _loc('Harvest Nature'),
				ns_id   => 0,
				ns_data => { $r->get_columns },
			});
		}
		return \@ns;
	},
};

register 'provider.harvest.users' => {
	name	=>'Harvest Users',
	config	=> 'config.harvest.db',
	list	=> sub {
		my ($self,$b)=@_;
		
		my $conn = $b->stash->{'config.harvest.db.connection'};
		my $username = $b->stash->{'config.harvest.db.connection.username'};
		my $password = $b->stash->{'config.harvest.db.connection.password'};
		
		$b->log->debug('Providing the user list');
	},
};

register 'config.harvest.db.grid.package' => {
	metadata => [
		{ id=>'packagename', label=>'Package', type=>'text' },
		{ id=>'environmentname', label=>'Project', type=>'text' },
		{ id=>'statename', label=>'State', type=>'text' },
		{ id=>'viewname', label=>'View', type=>'text' },
		{ id=>'username', label=>'Asigned to', type=>'text' },
		{ id=>'formdata', label=>'Form', type=>'text' },
	]
};
BEGIN {  extends 'Catalyst::Controller' }

#__PACKAGE__->config->{namespace} = '/ca/harvest';
sub packages_json : Path('/ca/harvest/packages_json') {
	my ($self,$c) = @_;
	my $rs = $c->model('Harvest::Harpackage')->search({ packageobjid => { '>', '0' } });
	my @data;
	while( my $row = $rs->next ) {
		my $rs_af = $row->harassocpkgs;
		while( my $af = $rs_af->next ) {
			my $aa = $af->formobjid;
		}
		push @data, { 
			packageobjid => $row->packageobjid,
			packagename => $row->packagename,
		};
	}
	$c->stash->{json} = { data=> @data };
	$c->forward('View::JSON');
}

1;
