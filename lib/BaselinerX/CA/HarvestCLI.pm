package BaselinerX::CA::HarvestCLI;
use Baseliner::Plug;
use Baseliner::Utils;
use Path::Class::Dir; 

register 'config.ca.harvest.cli' => {
    metadata => [
        { id=>'broker' },
        { id=>'login' },
        { id=>'project' },
        { id=>'state' },
    ]
};
register 'service.ca.harvest.promote' => {
    config => 'config.ca.harvest.cli',
    handler =>  sub {
        my ($self, $c, $inf)=@_;
        my $cli = __PACKAGE__->new( broker=>$inf->{broker}, login=>$inf->{login} );
        $cli->promote( state=>$inf->{state}, project=>$inf->{project}, packages=>[ @ARGV ] );
    }
};

## General attributes
has 'tempdir' => ( is=>'rw', isa=>'Str', default=>$ENV{TEMP} );
has 'harvesthome' => ( is=>'rw', isa=>'Str', default=> $ENV{HARVESTHOME} );
has 'log' => ( is=>'rw', isa=>'Catalyst::Log', default=>sub {  Baseliner->c->log() } );
## Context attributes
has 'broker' => ( is=>'rw', isa=>'Str', default=>'localhost' );
has 'login' => ( is=>'rw', isa=>'Str', default=>"$ENV{HARVESTHOME}/scm.dfo" );
has 'project' => ( is=>'rw', isa=>'Str' );
has 'state' => ( is=>'rw', isa=>'Str' );

our %cmd_map = ( promote=>'hpp', demote=>'hdp', checkin=>'hci', checkout=>'hco' );

sub _logfile {
    my ($self,$prefix)=@_;
    Path::Class::Dir->new( $self->tempdir . "/$prefix$$-"._nowstamp.".log" );
}

sub _quote { '"'.join('","', @{ $_[0] || [] }) . '"'; }

sub run {
    my ($self, %p)=@_;
	my $logfile = $self->_logfile( $p{cmd} );
    my $args;
    for( grep /^\-/, keys %p ) {
        $args.= qq{ $_ "$p{ $_ }" };  ## ie. -en aaaa"
    }
    if( ref $p{args} eq 'ARRAY' ) {
        $args.= " ". _quote( $p{args} );
    } else {
        $args.= $p{args};
    }
    my $farg = $self->write_argfile(qq{-o "$logfile" -b "$self->{broker}" $self->{login} $args }); #"
    my @RET = `$p{cmd} -i $farg 2>&1`;				
    my $rc = $?;
    my $ret = capture_log($logfile,@RET);
    return wantarray ? ( rc=>$rc, ret=>$ret ) : { rc=>$rc, ret=>$ret };
}

sub promote {
    my ($self, %p)=@_;
    $self->transition( cmd=>'promote', %p );
}

sub transition {
    my ($self, %p)=@_;
    die "Error: no packages selected for promote" if( ! ref $p{packages} );
    my $k = @{ $p{packages} };
    my $cmd = $cmd_map{ $p{cmd} };
    $p{project} ||= $self->project;
    $p{state} ||= $self->state;
    my $packages = '"'.join('","', @{ $p{packages} || [] }) . '"';
    my $r = $self->run( cmd=>$cmd, -en=>$p{project}, -st=>$p{state}, args => $p{packages} );
    if( $r->{rc} eq 0) {
        warn "Promote of $k package(s) ok in $p{en}.", $r->{ret}
    }
    else { 				
        warn "Error during promotion.", $r->{ret};
    }
}

sub write_argfile {
	my ($self, $data) = @_;
    my $infile = Path::Class::Dir->new($self->tempdir . "/harvestparam$$-"._nowstamp().".in");
	open FIN,">$infile" or die "Error: could not create argument file '$infile': $!";
	print FIN $data;
	close FIN;
	return $infile;
}

sub capture_log {   
	my $logfile = Path::Class::Dir->new(shift);
	my @RET;
	push @RET, @_;
	if( (-e $logfile) && (open(LOG,"<$logfile") ) ) {
		my @LogFile=<LOG>;
		close(LOG);
		unlink $logfile unless($logfile eq "");
		push @RET,@LogFile;
	}
	return join '', @RET;
}
1;
