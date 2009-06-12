package BaselinerX::CA::Endevor;
use Baseliner::Plug;

use Baseliner::Utils;
use BaselinerX::Comm::MVS;

use MVS::JESFTP;
use Carp;
 
use YAML;

## inheritance
use vars qw($VERSION);
$VERSION = '1.0';

## publish methods

register 'config.endevor.templates' => {
	metadata => [
		{ id=>'path', label=>'Path to Templates', default=>'root/endevor' },
	],
};
register 'config.endevor.connection' => {
	metadata => [
		{ id=>'host', label=>'Hostname' },
		{ id=>'user', label=>'UserID' },
		{ id=>'pw', label=>'Password'  },
		{ id=>'surr', label=>'Surrogate user id' },
		{ id=>'class', label=>'Job Class', default=>'E' },
		{ id=>'timeout', label=>'Timeout', default=>90 },
		{ id=>'package', label=>'Package'},
	],
};

register 'service.endevor.list_pkgs' => {
	name => 'Endevor Package List SCL',
	config => 'config.endevor.connection',
	handler => sub {
		my ($self,$c,$inf)=@_;
		eval {
			alarm $inf->{timeout};
			$SIG{ALRM}=sub { die _loc "Timeout Error (timeout=".$inf->{timeout}."s) while connected to MVS" };
			my $ret;
			my $e = __PACKAGE__->new( host=>$inf->{host}, user=>$inf->{user}, pw=>$inf->{pw}, surr=>$inf->{surr}, class=>$inf->{class});
			my %pkgs = $e->pkgs;
            warn( Dump \%pkgs );
			for( keys %pkgs ) {
				print "PKG=$_, TYPE=",$pkgs{$_}{'PKG_TYPE'},",STATUS=$pkgs{$_}{'STATUS'}, DESC=$pkgs{$_}{DESCRIPTION}, TARGET_ENV=$pkgs{$_}{PROM_TGT_ENV}\n";
			}

			##(my $rc = $ret)=~ s{^.*\n\s+EXECUTE.*(\Q$package\E\s+)(\d+)\s*.*$}{$2}sg ;   ##s{^.*END OF EXECUTION LOG - HIGHEST ENDEVOR RC =(.*?)\n.*$}{$1}gs;
			$ret && (my $rc = $ret)=~ s{^.*Highest return code is (\d+).*$}{$1}sg; 
			#  join(',',unpack('c*',$rc))
			$rc && print "\n\nRETURN CODE = [".$rc."]\n";
		};
		print "ERROR: $@" if $@;
	}
};

register 'service.endevor.execute' => {
	name => 'Endevor Execute Package SCL',
	config => 'config.endevor.connection',
	handler => sub {
		my ($self,$c,$inf)=@_;
		eval {
			alarm $inf->{timeout};
			$SIG{ALRM}=sub { die _loc "Timeout Error (timeout=".$inf->{timeout}."s) while connected to MVS" };
			my $ret;
			my $e = __PACKAGE__->new( host=>$inf->{host}, user=>$inf->{user}, pw=>$inf->{pw}, surr=>$inf->{surr}, class=>$inf->{class});
			my $output = $e->execute_pkg( $inf->{package} );
            print $output;
			##(my $rc = $ret)=~ s{^.*\n\s+EXECUTE.*(\Q$package\E\s+)(\d+)\s*.*$}{$2}sg ;   ##s{^.*END OF EXECUTION LOG - HIGHEST ENDEVOR RC =(.*?)\n.*$}{$1}gs;
			$ret && (my $rc = $ret)=~ s{^.*Highest return code is (\d+).*$}{$1}sg; 
			#  join(',',unpack('c*',$rc))
			$rc && print "\n\nRETURN CODE = [".$rc."]\n";
		};
		print "ERROR: $@" if $@;
	}
};

#TODO get endevor packages in namespace
register 'namespace.endevor.packages' => {
	name	=>'Endevor Packages',
	root    => '/apl',
	handler => sub {
		my @ns;
		return \@ns;
	},
};

sub new {
	my $class = shift();
	my %opts = @_;
	
	$opts{timeout}||=20;
	$opts{class}||='G';  ## it could be E instead
	
	my $self = {
		opts=> \%opts,
		jobcount => 0,
		jes => ''
	};
	
	$self = bless( $self, $class);
	$self->{mvs} = BaselinerX::Comm::MVS->open( host=>$self->opts->{'host'}, user=>$self->opts->{'user'}, pw=>$self->opts->{'pw'} );
	return $self;
}

sub opt { $_[0]->{opts}->{$_[1]} }
sub opts { $_[0]->{opts} }
sub __loc { Baseliner->loc( @_ ); }

use Text::Template;
sub parse_template {
	my ($self, $template, %h ) = @_;
	$template = Baseliner->path_to('root','endevor',$template) ;
	my $tt = Text::Template->new( 
					TYPE => "FILE",
                    SOURCE => $template ) or _throw _loc("Could not open template file %1", $template);
	my $jcl = $tt->fill_in( 
		HASH=> \%h,
		BROKEN => sub { 
			my %p=@_; 
			_throw _loc("Error loading the Endevor template '%1': '%2'",$p{template},$p{text} ); 
		},
		DELIMITERS => [ '<%','%>' ] 
	);
	return $jcl;
}

sub pkgs {
	my $self = shift;
	my $mvs = BaselinerX::Comm::MVS->open( host=>$self->opt('host'), user=>$self->opt('user'), pw=>$self->opt('pw') );
	my $class = $self->opt('class'); 
	my $surr = $self->opt('surr') ? 'USER='.$self->opt('surr').',' : '';
	# parse template
	my $jcl = $self->parse_template( 'pkg_list.jcl', class=>$class, surr=>$surr );
	# execute job
	my $output = $mvs->do( $jcl );
	my $jobout = $output;
	unless( $output=~ s{.*"PKG ID}{"PKG ID}gs ) {
		Carp::croak _loc("endevorPkgs: Error: unexpected job output:\n%1", $jobout);
	} else {

    open FF,">","output.log";
    print FF $output;
    close FF;
		$output=~ s{]] END OF JES SPOOL.*}{}gs;
		my $cnt = 0;
		my %pkgs =();
		my @cols = ();
		for ( split /\n/, $output ) {
			my @r = split( /,/ , $_ );
			if( ! $cnt++ ) {
				push @cols, @r;
				next;
			}  
			(my $pkg = $r[0])=~ s{(^\")|(\"$)}{}g;  ## remove leading, trailing double quotes
			next if ( ! $pkg or $pkg=~ /^\s*$/ )  ;
			for( 0..@cols ) {
				next unless $cols[$_];
				(my $colname = $cols[$_])=~ s{(^\")|(\"$)}{}g;
				$colname=~ s{\s}{\_}g;
				($pkgs{$pkg}{$colname} = $r[$_])=~ s{(^\")|(\"$)}{}g 
					if( $r[$_] );		
			}
		}
		return %pkgs if defined wantarray;	
	}
}

sub pkgcsv {
	my $self = shift;
	my $mvs = BaselinerX::Comm::MVS->open( host=>$self->opt('host'), user=>$self->opt('user'), pw=>$self->opt('pw') );
	my $class = $self->opt('class'); 
	my $surr = $self->opt('surr') ? 'USER='.$self->opt('surr') : '';
	my $jcl = $self->parse_template( 'pkg_list_csv.jcl', class=>$class, surr=>$surr );
	my $output = $mvs->do( $jcl );
	my $jobout = $output;
	unless( $output=~ s{.*"PKG ID}{"PKG ID}gs ) {
		Carp::croak _loc("endevorPkgs: Error: unexpected job output:\n%1", $jobout);
	} else {
		$output=~ s{]] END OF JES SPOOL.*}{}gs;
		my $cnt = 0;
		my %pkgs =();
		my @cols = ();
		for ( split /\n/, $output ) {
			my @r = split( /,/ , $_ );
			if( ! $cnt++ ) {
				push @cols, @r;
				next;
			}  
			(my $pkg = $r[0])=~ s{(^\")|(\"$)}{}g;  ## remove leading, trailing double quotes
			next if ( ! $pkg or $pkg=~ /^\s*$/ )  ;
			for( 0..@cols ) {
				(my $colname = $cols[$_])=~ s{(^\")|(\"$)}{}g;
				$colname=~ s{\s}{\_}g;
				($pkgs{$pkg}{$colname} = $r[$_])=~ s{(^\")|(\"$)}{}g;		
			}
		}
		return %pkgs if defined wantarray;	
	}
}

sub execute_pkg {  ## all in one execution
	my $self = shift;
	my $package = shift || die "Missing package parameter."; 
	my $mvs = BaselinerX::Comm::MVS->open( host=>$self->opt('host'), user=>$self->opt('user'), pw=>$self->opt('pw') );
	my $class = $self->opt('class');
	my $surr = $self->opt('surr') ? 'USER='.$self->opt('surr').'' : '';
	my $jcl = $self->parse_template( 'pkg_exec.jcl', class=>$class, package=>$package, surr=>$surr );
	my $output = $mvs->do( $jcl );
	return $output;		
}

sub submit_pkg {
	my $self = shift;
	my $package = shift || die "Missing package parameter."; 
	my $class = $self->opt('class'); 
	my $jcl = $self->parse_template( 'pkg_submit.jcl', class=>$class, package=>$package );
	my $jobid = $self->{mvs}->submit( $jcl ); 
	my $jobname = $self->{mvs}->name( $jobid );
	my $jobtxt = $self->{mvs}->jobtxt( $jobid );
	return ($jobid, $jobname, $jobtxt);
}

sub wait_for {
	my $self = shift;
	my $jobid = shift;
	return $self->{mvs}->waitFor( $jobid );
}

sub parse_rc_pkg {
	my $self = shift;
	my $package = shift;
	##(my $rc = shift) =~ s{^.*\n\s+EXECUTE.*(\Q$package\E\s+)(\d+)\s*.*$}{$2}sg;
	(my $rc = shift)=~ s{^.*Highest return code is (\d+).*$}{$1}sg; 
	if( length($rc) > 3 ) {
		$rc = 99;
	}
	return $rc;
}

sub acts {
	my $self = shift;
	my $mvs = BaselinerX::Comm::MVS->open( host=>$self->opt('host'), user=>$self->opt('user'), pw=>$self->opt('pw') );
	my $class = $self->opt('class');
	my $jcl = $self->parse_template( 'act_list.jcl', class=>$class );
	my $output = $mvs->do( $jcl );
	print $output;	
}

sub endevorPkgs {
	
}

sub jobNumber
{
	my $self=shift;
	my $Message = shift @_;
	return substr($Message,index($Message,"JOB"),8);			# Busca el número de JOB y lo devuelve
}

sub jobLetter {
	my $self=shift;
	my $id = shift;
	$id = $id % 25;
	return chr(65 + $id);
}
sub checkJobs
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

DESTROY {
	my $self = shift;
	ref $self->{mvs} && $self->{mvs}->close();
}
1;
