#############################################################
#
# SSH.pm - communication framework with ssh
#

package BaselinerX::Comm::SSH;
use Baseliner::Plug;

use IO::Socket;
require Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Carp;

use constant 'DEBUG' => $ENV{BASELINER_DEBUG} || 0;

@ISA = qw();
@EXPORT = qw();
$VERSION = '1.0';

my ($RM,$RPORT,$RUSR,$RPWD,$FS) = ();

#register 'comm.ssh' => {  };
 
use Filesys::Virtual::SSH;
use Net::SCP qw(scp iscp);
require File::Path; 

sub open {
	my $class = shift @_;
	my $maq = shift @_; 

	my $harax;
	$harax->{PARAMS} = { @_ };
	$harax->{WIN}=1 if $harax->{PARAMS}{OS} =~ m/win/i;
	
	if( $maq =~ /@/ ) {
		($RUSR,$RM) = split /\@/, $maq; ##/
	} else {
		$RM = $maq;
		$RUSR = ( $harax->{WIN} ? $ENV{STAWINUSR} : $ENV{STAUNIXUSR} );
	}

	$harax->{RM} = $RM; ## remote machine
	my $host = ( $RUSR? $RUSR.'@'.$RM : $RM );  ## if user is defined, connect with it
	
	$harax->{FS} = Filesys::Virtual::SSH->new({
		 host      => $host,
		 cwd       => '/',
		 root_path => '/',
		 home_path => "$ENV{HOME}",
	});
	
	$harax->{host} = $host;
	$harax->{RUSR} = $RUSR;

	$harax->{scp} = Net::SCP->new( { "host"=>$harax->{RM}, "user"=>$harax->{RUSR} } );
	die "Could not connect SCP to  $harax->{RUSR}\@$harax->{RM}: $!" unless $harax->{scp};
	my $self = bless($harax,$class);
	
	unless( $harax->{WIN} ) {
		my ($rc,$ret) = $harax->execute("set");
		$harax->{WIN}=1 if $ret=~ /OS=win/i;
	} 
	
	$self;
}

sub sendFile {
	my ($harax, $localfile, $rfile) = @_;
	my $fs = $harax->{FS};
	
	$rfile = $localfile unless($rfile);
	$rfile=~ s{\\}{\\\\\\\\}g if( $harax->{WIN} );	
	if( ! -e $localfile ) {
		die "sendFile: the file '$localfile' does not exist.";
	}
	CORE::open FF,"<$localfile" or die "sendFile: Error: could not open the file $localfile: $!\n";
	binmode FF;

	my $RF = $fs->open_write($rfile);
	my ($RC,$RET) = ($?,"Error OPEN_WRITE: $!"); return($RC >> 8,$RET) if($RC);
	print $RF <FF>;
	($RC,$RET) = ($?,"Error PRINT: $!"); return($RC >> 8,$RET) if($RC);
	$fs->close_write($RF);
	($RC,$RET) = ($?,"Error CLOSE_WRITE (RC=$?): $!"); return($RC >> 8,$RET) if($RC);
}

sub sendData {
	my ($harax, $data, $rfile) = @_;
	my $fs = $harax->{FS};
	my $FF = $fs->open_write($rfile);
	print $FF $data;
	$fs->close_write($FF);
	my ($RC,$RET) = ($?,"");	
	return ($RC >> 8,$RET);
}

sub getFile {
	DEBUG && warn ahora()." - in getFile\n";
	my $self=shift;
	my ($rfile, $localfile) = @_;
	if( $self->{WIN} ) {
		$rfile=~ s{\\}{/}g;
		$self->{scp}->get($rfile, $localfile) or print  $self->{scp}->{errstr};
	} else {
		##TODO: esto lo haría con SCP tambien
		my $FF;
		$FF = $self->{FS}->open_read($rfile);
		if($localfile) {
			CORE::open FOUT,">$localfile" 
				or die "Error: Could not open local file $localfile";
			binmode FOUT;
			print FOUT <$FF>;
			close FOUT;
			$self->{FS}->close_read($FF);
			return (0,"");
		}
		else {
			my $data=<$FF>;
			$self->{FS}->close_read($FF);
			return (0,$data);
		}
		
	}
		
}

sub get_file {
	my $self=shift;
	my ($rfile, $localfile) = @_;
	##DEBUG && warn ahora()." - get_file 1 parms: $self, $rfile, $localfile \n";
	if( $self->{WIN} ) {
		$rfile=~ s{\\}{/}g;
		##DEBUG && warn ahora()." - get_file parms: $self, $rfile, $localfile \n";
		$self->{scp}->get($rfile, $localfile) or print  $self->{scp}->{errstr};
		##DEBUG && warn ahora()." - get_file ok.\n";
	}	
}

sub getDir {
	my ($harax, $rdir, $localdir) = @_;
	my $fs = $harax->{FS};
	my $findcmd = $harax->{WIN} ? qq{cmd /c dir /b /s /aa $rdir } : qq{ find $rdir };
	my ($RC,$RET) = $harax->execute( $findcmd );
	$RET=~ s{\r}{}g if $harax->{WIN};
	my %Paths=();
	for( split /\n/, $RET ) {
		next unless $_;
		DEBUG && warn "Getting $_\n";		
		(my $rempath = $_ ) =~ s{\Q$rdir\E}{}g;
		$rempath=~s{\\}{/}g;
		my $localfile = $localdir."/".$rempath;
		$localfile=~ s{//}{/}g;
		(my $localpath = $localfile) =~ s{^(.*)/(.*?)$}{$1}g;
		unless( exists $Paths{$localpath} ) {
			DEBUG && warn "Making path $localpath\n";
			File::Path::mkpath($localpath) or print "Mkpath error: $!"; 		
		}		
		$Paths{$localpath}=1;
		DEBUG && warn "NOw the file $_ to $localfile\n";		
		$harax->get_file( $_, $localfile);
	}
	return( 0, '');
}

sub execute {
	my ($harax, $rcmd) = @_;
	my $fs = $harax->{FS};
	
	$rcmd=~ s{\\}{\\\\\\\\}g if( $harax->{WIN} );	
	$rcmd=~ s{"}{\\"}g if( $harax->{WIN} );
	my $RET = $fs->_remotely($rcmd);
	my $RC = $?;
	return($RC >> 8,$RET);
}

sub executeas {
	## uses a pub key to get there with "as" user
	my ($harax, $user, $rcmd) = @_;
	my $rm = $harax->{RM};
	if( $user eq "" ) {
		return (99,"ERROR HARAX-SSH: remote user parameter is blank!");
	}
	 my $fs = Filesys::Virtual::SSH->new({
		 host      => "$user\@$rm",
		 cwd       => '/',
		 root_path => '/',
		 home_path => '/',
	 });
	my $RET = $fs->_remotely($rcmd);
	my $RC = $?;
	return($RC >> 8,$RET);
}

sub _executeas {
####IF NOT CONNECTED WITH ROOT, WILL ASK FOR PASSWORD!
	my ($harax, $user, $rcmd) = @_;
	my $fs = $harax->{FS};
	if( $user eq "" ) {
		return (99,"ERROR ".__PACKAGE__.": remote user parameter is blank!");
	}
	$rcmd =~ s/\"/\\\"/g;  	#"
	my $RET = $fs->_remotely("su - $user -c $rcmd");
	my $RC = $?;
	return($RC >> 8,$RET);
}

sub end {
	my($harax) = @_;
	undef $harax->{FS};
}

sub DESTROY {
	my($harax) = @_;
	$harax->end();
}

sub ping {
	my ($harax, $hostname)  = @_;
	my $fs = $harax->{FS};

	my $RET = $fs->_remotely("echo $hostname");
	my $RC = $?;
	my $byte = substr($RET,0,1);
	
	if ( $byte ne substr($hostname,0,1) ) {
		$RET = "Server is not responding. Make sure that SSH is installed and has a valid public key.";
		$RC = 1;
	}
	return ($RC,$RET);
}

1;
