package BaselinerX::CA::HarvestDB;
use Baseliner::Plug;

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

1;
