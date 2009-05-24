package BaselinerX::Comm::MVS;
use Baseliner::Plug;
use Baseliner::Utils;

use MVS::JESFTP;
use Carp;
#use Error qw(:try);

## inheritance
use vars qw($VERSION);
$VERSION = '1.0';

sub opt { $_[0]->{opts}->{$_[1]} }
sub opts { $_[0]->{opts} }

sub new {
	my $class = shift();
	my %opts = @_;
	my %jobs=();
	
	$opts{timeout} ||= 20;
	$opts{tempdir} ||=  $ENV{TEMP} ? "$ENV{TEMP}/jobs" : "./mvsjobs"  ;
	
	my $self = {
		opts=> \%opts,
		jobcount => 0,
		jes => '',
		jobs => \%jobs
	};
	bless( $self, $class);
}

sub open {
	my $self=shift;
	if( ! ref $self ) {
		$self = __PACKAGE__->new( @_ );
	}
	$self->{jes} = MVS::JESFTP->open($self->opts->{'host'}, $self->opts->{'user'}, $self->opts->{'pw'}) 
		or confess _loc("Could not logon to host %1, user: %2: %3", $self->opts->{'host'}, $self->opts->{'user'}, $! );

	mkdir $self->opt('tempdir')
		if( ! -d $self->opt('tempdir') );
	confess _loc("Could not find a temporary job directory '%1'", $self->opt('tempdir') ) 
		if( ! -d $self->opt('tempdir') );
	return $self if defined wantarray;
}

sub submit {
	my $self=shift;
	my @jobs;
	while ( my $jobtxt = shift @_ ) {
		my $tempdir = $self->opt('tempdir');
		my $jobfile = $tempdir."/pkg".sprintf('%05d',$self->{jobcount}++).".jcl";
		my $jobname = $self->_genjobname(); 
		warn "JOBNAME=$jobname";
		if( ! $self->opt('keep_name') ) {
			$jobtxt =~ s{^//[A-Z]*}{//$jobname}s;  ## replace job code with generated job code
		} 
		
		##else {
		##	( $jobname = $jobtxt ) = ~ s{^(//[A-Z]*).*$}{$1}; ## extract the job name from the job code
		##}
		
		CORE::open JF, ">$jobfile";
		print JF $jobtxt;
		close JF;
	warn $jobtxt;
		$self->{jes}->submit($jobfile) || confess _loc("Could not submit job '%1'", $jobname);
		unlink $jobfile;
			
		my $msg = $self->{jes}->message;
		my $JobNumber = $self->_jobnumber($msg);
		$self->{jobs}{$JobNumber}{status} = 'Submitted';
		$self->{jobs}{$JobNumber}{name} = $jobname;
		$self->{jobs}{$JobNumber}{job} = $jobtxt;
		push @jobs, $JobNumber;
	}
	
	return wantarray ? @jobs : shift @jobs;
}

sub name {
	my $self = shift;
	my $jobid = shift;
	return $self->{jobs}{$jobid}{name};
}

sub jobtxt {
	my $self = shift;
	my $jobid = shift;
	return $self->{jobs}{$jobid}{job};
}

sub do {
	my $self = shift;
	my $num = $self->submit( shift );
	return (wantarray ? 
		($num,$self->waitFor( $num ) )
		: $self->waitFor( $num )
	  );
}

sub wait {
	my $self=shift;

WW:	while( $self->pending ) {
		for ( $self->checkjobs ) {
			my $num = $self->_jobnumber( $_ );
			$self->{jobs}{$num}{status}='Finished';			
		}
	}
		
}

sub pending {
	my $self=shift;
	my @ret;
	for( $self->jobs ){
		push @ret, $_ if $self->{jobs}{$_}{status} eq 'Submitted';
	} 
	return @ret; 
}

sub waitFor {
	my $self=shift;
	my $JobNumber = shift;

WW:	while( 1 ) {
		for ( $self->checkjobs ) {
			my $num = $self->_jobnumber( $_ );
			$self->{jobs}{$num}{status}='Finished';
			last WW if $num eq $JobNumber;   			
		}
	}
	return $self->output( $JobNumber);
}

sub output {
	my $self=shift;
	my $JobNumber = shift;
	my $jobout = $self->opt('tempdir')."/$JobNumber.out";
	$self->{jes}->get($JobNumber,$jobout);
	my $output;
	CORE::open JO, "<$jobout";
	$output.= "$_" for <JO>;
	close JO;
	unlink $jobout;
	$self->{jes}->delete($JobNumber) unless( $ENV{MVS_NOPURGE} );;
	return $output;	
}

sub close {
	my $self=shift;
	for( $self->jobs ) {
		$self->{jes}->delete( $_ ) unless( $ENV{MVS_NOPURGE} );
	}
	rmdir $self->opt('tempdir');
	$self->{jes}->quit();				
}

sub jobs {
	my $self=shift;
	return keys %{$self->{jobs}};	
}

sub submitFile {
	my $self=shift;
	##TODO
}

sub checkjobs
{
	my $self=shift;
	my $JES = $self->{jes};
	my $i = 0;
	my @Dir = "";

	while (++$i <= $self->opt('timeout') )			# Espera el tiempo especificado en TIMEOUT
	{
		last if (@Dir = grep /OUTPUT/,$JES->dir); # Solo los JOBS en OUTPUT
		sleep(1);
	}
	return @Dir;					# Devuelve lista de JOBs en OUTPUT
}

sub _jobnumber
{
	my $self=shift;
	my $Message = shift @_;
	return substr($Message,index($Message,"JOB"),8);			# Busca el número de JOB y lo devuelve
}

sub _queuesize {
	my $self=shift;
	my $k=0;
	for( keys %{$self->{jobs} } ) {
		$k++ if $self->{jobs}{$_}{status} eq 'Submitted';
	}
	return $k;
}

sub _genjobname {
	my $self=shift;
	my $user = uc($self->opt('user'));
	my $id = $self->_queuesize;
	$id = $id % 25;
	return ($user.chr(65 + $id) );
}

DESTROY {
	my $self=shift;
	$self->close();
}

=head1 SYNOPSIS
Submits jobs thru the JES queue using MVS::JESFTP;

	my $mvs = Baseliner::Comm::MVS->open( host=>'mybigcpu', user=>'myuser', pw=>'mypassword' );
	my $job = $mvs->submit( $jobtxt1 );
	## submit more here if you want
	$mvs->wait();  ## wait till all submitted jobs are thru
	my $output = $mvs->output($job);
	
Or you can submit a few at once:

	my $mvs = Baseliner::Comm::MVS->open( host=>'mybigcpu', user=>'myuser', pw=>'mypassword' );
	my ($job1,$job2,$job3...) = $mvs->submit( $jobtxt1,$jobtxt2,$jobtxt3... );
	$mvs->wait();
	my $output = $mvs->output($job);	
	
Or just quick-and-dirty:

	my $mvs = Baseliner::Comm::MVS->open( host=>'mybigcpu', user=>'myuser', pw=>'mypassword' );
	my $output = $mvs->do( <<JOBEND );  ## will wait for it to end and return its output
//jobnameA ....		

=cut 

1;
