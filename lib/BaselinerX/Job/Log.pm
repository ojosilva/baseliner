package BaselinerX::Job::Log;
use Baseliner::Plug;
use Baseliner::Utils;
use JavaScript::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#__PACKAGE__->config->{namespace} = 'job/log';

register 'menu.job.logs' => { label => 'Logs', url_comp => '/job/log/list', title=>'Logs' };
register 'config.job.log' => {
	metadata => [
		{ id=>'job_id', label=>'Job', width=>200 },
		{ id=>'log_id', label=>'Id', width=>80 },
		{ id=>'level', label=>_loc('Level'), width=>80 },
		{ id=>'text', label=>_loc('Message'), width=>200 },
	]

};

=head1 Logging

The basics:

	my $job = $c->stash->{job};
	my $log = $job->logger;
	$log->error( "An error" );

With data:

	$log->error( "Another error", data=> $stdout_file );

=cut

has 'jobid' => ( is=>'rw', isa=>'Int' );

sub common_log {
	my ( $level, $self, $text, %p )=@_;
	my $row = Baseliner->model('Baseliner::BaliLog')->create({ id_job =>$self->jobid, text=> $text, lev=>$level }); 
	$p{data} && $row->data( $p{data} );
	$row->update;
}

sub warn { common_log('warn',@_) }
sub error { common_log('error',@_) }
sub fatal { common_log('fatal',@_) }
sub info { common_log('info',@_) }
sub debug { common_log('debug',@_) }

sub logs_json : Path('/job/log/json') {
	my ( $self,$c )=@_;
	my $p = $c->request->parameters;
    my $query = $p->{query};
	my $config = $c->registry->get( 'config.job.log' );
	my @rows = ();
    #TODO filter by level: info, debug, etc.
    my $job = $c->model( 'Baseliner::BaliJob')->search({ id=>$p->{id_job} })->first;
    my $rs = $c->model( 'Baseliner::BaliLog')->search({ id_job=>$p->{id_job} }, { order_by=>'id' });
	while( my $r = $rs->next ) {
        next if( $query && !query_array($query, $r->text, $r->provider, $r->lev ));
        push @rows,
          {
            id       => $r->id,
            id_job   => $r->id_job,
            job      => $job->name,
            text     => $r->text,
            ts       => $r->get_column('ts'),
            level    => $r->lev,
            ns       => $r->ns,
            provider => $r->provider,
          };
	}
	$c->stash->{json} = {
        totalCount => scalar \@rows,
        data => \@rows
     };	
	$c->forward('View::JSON');
}

sub logs_data : Path('/job/log/data') {
    my ( $self, $c ) = @_;
	my $p = $c->req->params;
	my $log = $c->model('Baseliner::BaliLog')->search({ id=> $p->{id} })->first;
	$c->res->body( $log->data  . " " );
}

sub logs_list : Path('/job/log/list') {
    my ( $self, $c ) = @_;
	my $p = $c->req->params;
    $c->stash->{id_job} = $p->{id_job};
    $c->stash->{template} = '/comp/log_grid.mas';
}

1;
