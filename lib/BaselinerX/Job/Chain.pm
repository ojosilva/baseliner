package BaselinerX::Job::Chain;
use Baseliner::Plug;
use Baseliner::Utils;

use YAML;

register 'config.job.chain.runner' => {
	metadata => [
		{ id=>'jobid', required=>1 },
	]
};
register 'service.job.chain.runner' => {
	name => 'Job chain runner',
	handler => \&chain_runner,
};

sub chain_runner {
	my ($self, $c, $config )=@_;
	my $job = $c->stash->{job};
	my $log = $job->logger;

	$log->error( 'hello');
	$log->warn('not yet', data=>'francamente' );
}

1;
