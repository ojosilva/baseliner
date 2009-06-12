package BaselinerX::Setup::DB;
use Baseliner::Plug;
use YAML;

register 'config.util.db_connection' => {
	name => 'DB Connection Data',
	metadata => [
		{ id=> 'dsn', label=> 'DSN', type=> 'text' },
		{ id=> 'user', label=> 'Username', type=> 'text' },
		{ id=> 'pass', label=> 'Password', type=> 'text' },
	]	,
};

register 'service.util.create_db' => {
	name => 'Create the database from the Schema',
	config => 'config.util.db_connection',
	handler => sub {
		my ($self,$p)=@_;
		my ($dsn, $user, $pass) = ( $p->{dsn}, $p->{user}, $p->{pass} );
		print "PARAMS: ",Dump($_[1]), "\n";
		use FindBin '$Bin';
		use Baseliner::Schema::Baseliner;
		use Config::JFDI;
		my $jfdi = Config::JFDI->new(name => "Baseliner");
		my $config = $jfdi->get;
		eval {
			if (!$dsn) {
				($dsn, $user, $pass) =
				  @{$config->{'Model::DBIC'}->{'connect_info'}};
			};
		};
		if($@){
			die "Your DSN line in baseliner.conf doesn't look like a valid DSN.".
			  "  Add one, or pass it on the command line.";
		}
		die "No valid Data Source Name (DSN).\n" if !$dsn;
		$dsn =~ s/__HOME__/$FindBin::Bin\/\.\./g;
		my $schema = Baseliner::Schema->connect($dsn, $user, $pass) or 
		  die "Failed to connect to database";
		print "Deploying schema to $dsn\n";
		$schema->deploy;
		$schema->create_initial_data(language => $config->{default_lang} || 'en');		
	},
};


1;
