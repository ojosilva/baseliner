package BaselinerX::Eclipse;
use strict;
use Carp;
use File::Find;
use Error qw(:try);

sub new {
    my $class = shift();
    my %opts  = @_;
    my ( $dir, $locale ) = ( $opts{workspace}, $opts{locale} );
    $dir =~ s/\s//g;
    $dir .= "/";
    $dir = slashFwd($dir);
    $dir =~ s{//}{/}g;
    confess _loc( "$class: the workspace directory '%1' does not exist", $dir )
      if ( !-e $dir );
    my %W = discoverWorkspace($dir);
    confess _loc( "$class: the workspace directory '%1' is empty:", $dir ) .
      keys %W
      if ( !keys %W );

    my $self = {
        DIR  => $dir,
        opts => \%opts,
        W    => \%W,
        root => \%W
    };
    bless( $self, $class );
}

=head2 discoverWorkspace

Returns the XML snippet for packaging JARs

=cut

sub discoverWorkspace {
    my ($wks)  = @_;
    my $wksLen = length($wks);
    my %W      = ();             ## the workspace
    find(
        sub {
            my $full = "$File::Find::dir/$_";
            if ( $File::Find::name =~ m{/\.project$|/\.classpath$|/application\.xml$|MANIFEST\.MF$|/\.websettings$|/\.modulemaps$|/\.settings/org})
            {
                return if ( -d $File::Find::name );
                my $prj = slashFwd( substr( $File::Find::name, $wksLen ) );
                $prj =~ s{^(.*?)/.*$}{$1}g;
                my $class = $_;    #$class=~s{^\.(.*)$}{$1}g;
                my $path = slashFwd($File::Find::name);
                my $rel = substr( $path, $wksLen );

             #return if( $rel =~ m{^\.} );  ## no dirs that start with a "." dot
                return
                  unless ( -f "$wks/$prj/.project" );    ## no .project, no way
                $W{$prj}{"$class"}{path}     = $path;
                $W{$prj}{"$class"}{dir}      = slashFwd($File::Find::dir);
                $W{$prj}{"$class"}{filename} = slashFwd($_);
                $W{$prj}{"$class"}{relpath}  = $rel;
                ## parse file
                open FF, "<$W{$prj}{$class}{path}"
                  or confess(
                    _loc(
                        "discoverWorkspace: could not open files %1: %2",
                        $W{$prj}{$class}{path}, $!
                    )
                  );
                $W{$prj}{"$class"}{data} .= $_ while (<FF>);
                close FF;
                ## parse XML
                try {
                    print "Parseando $W{$prj}{$class}{path}...\n";
                    my $XML = XML::Smart->new( $W{$prj}{"$class"}{data} )
                      or confess _loc(
                        "discoverWorkspace: could not parse file %1: %2",
                        $W{$prj}{$class}{path}, $! );
                    $W{$prj}{"$class"}{xml} = \$XML if ($XML);
                }
                otherwise {    ##xml either not valid or not xml at all : ignore
                };
            }
        },
        $wks
    );
    return %W;
}

sub getSubsetWorkspace {
    my $self  = shift();
    my %W     = %{ $self->{root} };
    my %NEW_W = ();
    return $self if ( !@_ );
    for (@_) {
        $NEW_W{$_} = $W{$_};
    }
    return \%NEW_W;
}

sub cutToSubset {
    my $self = shift();
    $self->{root} = $self->getSubsetWorkspace(@_);
}

sub reset {
    my $self = shift();
    $self->{root} = $self->{W};
}

sub opt {
    my $self = shift();
    return '' if !@_;    ## false if opt is not an arg
    return $self->{opts}{ shift() };
}

sub _unique {
    keys %{ { map { $_ => 1 } @_ } };
}
sub _loc { print( @_, "\n" ); }

sub slashFwd {
    $_[0] =~ s{\\}{/}g;
    return $_[0];
}

=head2 projects()

Returns the list of valid projects in the workspace. 

Even though $self->{W} should have only valid projects loaded by discoverWorkspace(), projects(), valid() and isa_project() may be used to recheck validity on new constraints. 

=cut

sub projects {
    my $self = shift();
    my %W    = %{ $self->{root} };
    return grep { ( $_ && exists $W{$_}{".project"}{xml} ) } sort keys %W;
}

=head2 valid(@LIST)

Returns the list of valid projects from the list parameter of possible projects. This serves to filter user input.

=cut

sub valid {
    my $self = shift();
    return () if ( !@_ );
    return grep { $self->isa_project($_) } _unique @_;
}

=head2 isa_project(LIST)

Returns a bool if the project is a valid project.

=cut

sub isa_project {
    my $self = shift();
    my %W;
    @W{ $self->projects() } = ();
    return '' if !@_;
    for (@_) {
        if ( !exists $W{$_} ) {
            $@ = $_;
            return 0;
        }
    }
    return 1;
}

1;

__END__

=head1 NAME

BaselinerX::Eclipse - base abstract class for loading an Eclipse Workspace into a Workspace data structure.

=head1 SYNOPSIS

          ## create the object and load files
          my $Wks->BaselinerX::Eclipse::J2EE->new('/anydir/workspace');           
          
          ## figure out files in memory
          $Wks->parseWorkspaceJ2EE();

          ## generate the build.xml data
          my $xml = $Wks->getBuildXML( 
                                 CLASSPATH => "/javadir/classes",
                                 JAVAC => 'source="1.4"'
                                 );          
          
          ## printing is believing
          print $xml->{data};
          
          ## save the file
          $xml->save('/dir/build.xml');
          
          ## call ant -f /dir/build.xml clean build package

=head1 DETAILS

Workspace project folders that start with a dot "." will be skipped. That is only true for first level folders.

=over

=head1 TODO

More method abstraction and less direct data access.

Allow more than one workspace to be parsed simultaniously.

=over

=head1 VERSION

Version 1.0  (Sep 12 2008)

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008 The Authors of Baseliner.org. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
