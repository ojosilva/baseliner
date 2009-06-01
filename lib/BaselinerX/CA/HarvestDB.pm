package BaselinerX::CA::HarvestDB;
use Baseliner::Plug;

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
