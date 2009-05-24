package BaselinerX::Job::Log;
use Baseliner::Plug;
use Baseliner::Utils;
use JavaScript::Dumper;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config->{namespace} = 'job/log';

register 'menu.job.logs' => { label => 'Logs', url_comp => '/job/log/list', title=>'Logs' };

register 'config.job.log' => {
	metadata => [
		{ id=>'job_id', label=>'Job', width=>200 },
		{ id=>'log_id', label=>'Id', width=>80 },
		{ id=>'level', label=>_loc('Level'), width=>80 },
		{ id=>'text', label=>_loc('Message'), width=>200 },
	]

};

sub logs_json : Local {
	my ( $self,$c )=@_;
	my $p = $c->request->parameters;
	my $config = $c->registry->get( 'config.job.log' );
	my @rows = ();
	my $q = $p->{job_id} ? { job_id=>$p->{job_id} } : undef;
	for( $c->model( 'BaliLog')->search($q, { order_by=>'id' }) ) {
		push @rows, { job_id=>$_->job_id, log_id=>$_->id, text=> $_->text, level=>$_->level }	
	}
	#my @rows = $config->rows( query=> $p->{query}, sort_field=> $p->{'sort'}, dir=>$p->{dir}  );
	$c->stash->{json} = { cat => \@rows };	
	$c->forward('View::JSON');
}

sub list : Local {
    my ( $self, $c ) = @_;
	my $jobid = $c->req->params->{jobid};
    $c->languages( ['es'] );
	my $config = $c->registry->get( 'config.job.log' );
    $c->stash->{url_store} = '/job/log/logs_json';
    $c->stash->{title} = $c->localize('Logs');
    $c->stash->{columns} = js_dumper $config->grid_columns;
    $c->stash->{fields} = js_dumper $config->grid_fields;

    $c->stash->{template} = [$config->column_order];
    $c->stash->{ordered_fields} = [$config->column_order];
    $c->stash->{template} = '/comp/log.mas';
}

1;