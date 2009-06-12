package BaselinerX::Eclipse::J2EE;
use strict;
use base 'BaselinerX::Eclipse';
use Data::Dumper;

use XML::Smart;
use File::Find;
use Carp;
use YAML::Tiny;
use Error qw(:try);
use vars qw($VERSION @EXPORT @EXPORT_OK);

## inheritance
$VERSION = '1.0';

sub _unique {
    keys %{ { map { $_ => 1 } @_ } };
}
sub _loc { print( @_, "\n" ); }

sub dir {
    my $self = shift();
    $self->{DIR};
}

## publish methods

sub services {
    {

        'eclipsej2ee' => {
            verb   => 'parse',
            config => _config(),
            code   => sub { __PACKAGE__->eclipsej2ee(@_) }
          }

    };
}

sub _config {
    <<'...';
---
cmd:
          line: [options] eclipseproject1 [eclipseproject2 ...]
          example: bali eclipsej2ee -w /path/to/workspace -f output_build_file.xml eclipseproject1 [eclipseproject2 ...]
          desc: Parses given projects from a j2ee Eclipse workspace and generates an Ant build.xml file.
task:
          workspace: 
                      default: .
                      opt: w|workspace
                      label: workspace name
                      type: text
          projects: 
                      default:
          buildfile: 
                      default: build.xml
                      opt: f|buildfile
          mode: 
                      default: single
                      opt: m|mode
                      label: compile mode (ear|deps|single)
options:
          classpath:
                      opt: c|classpath
                      label: additional classpath entries to be used by javac (.jar, .zip or directory)
          javac-opts:
                      opt: j|javac
                      label: additional <javac> tag options
          static-ext:
                      opt: s|static-ext
                      label: comma separated static web extensions (gif,jpg,html,xml,...)
          dynamic-ext:
                      opt: d|dynamic-ext
                      label: comma separated dynamic web extentions (jsp,jar,zip,...)
          delete_opts:
          exclude:
          ear_exclude:
          jar_exclude:
          war_exclude:
          tar_exclude:
...
}

sub eclipsej2ee {
    my $self = __PACKAGE__->parse( shift() );
}

sub deprecated_setup {

    my $conf = new Baseliner::ConfigSet(
        'javac_opt' => 'jc',
        'Additional <javac> tag options'
    );
}

### output related stuff
sub output {
    my $self = shift();
    return @{ $self->{output} } if ref $self->{output};
}

sub genfiles {
    my $self = shift();
    return map { s{//}{/}g; $_ } map { $_->{file} } @{ $self->{output} }
      if ref $self->{output};
}

sub genfile {
    my $self = shift();
    my $prj  = shift();
    for ( $self->output() ) {
        return $_->{file} if ( $_->{class} eq $prj );
    }
}

sub xml {
    my $self = shift;
    my ( $data, $unicode ) = $self->{build}{xml}->data();
    return $data;
}

sub getProjects {
    my $self = shift();
    my %RET  = ();
    for ( keys %{ $self->{root} } ) {
        $RET{$_} = ();
    }
    return keys %RET;
}

### CLASS related methods
sub getProjectsByClass {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my $key  = shift();
    my %RET  = ();
    confess __PACKAGE__ . ": Missing key" if !$key;
    for ( @_ ? @_ : keys %W ) {
        $RET{$_} = () if exists $W{$_}{$key};
    }
    return sort keys %RET;
}

sub isClass {
    my $self = shift();
    return exists ${ $self->{root} }{ $_[0] }{ $_[1] };
}

sub getEarProjects  { return shift()->getProjectsByClass( "EAR",  @_ ); }
sub getWebProjects  { return shift()->getProjectsByClass( "WEB",  @_ ); }
sub getWarProjects  { return shift()->getProjectsByClass( "WAR",  @_ ); }
sub getEjbProjects  { return shift()->getProjectsByClass( "EJB",  @_ ); }
sub getJarProjects  { return shift()->getProjectsByClass( "JAR",  @_ ); }
sub getLibProjects  { return shift()->getProjectsByClass( "LIB",  @_ ); }
sub getJavaProjects { return shift()->getProjectsByClass( "JAVA", @_ ); }

sub getRelatedProjectsByClass {
    my $self  = shift();
    my $class = shift();
    grep { $self->isClass( $_, $class ) } $self->getRelatedProjects(@_);
}

sub getWarsFromEAR {
    my $self = shift();
    my %W    = %{ $self->{root} };
    keys %{ $W{ shift() }{WARMODULES} };
}

=head2 getRelatedProjects

Returns all EAR projects for 1 or more projects passed as arguments.

=cut

sub getRelatedProjects {    ##
    my $self = shift();
    my %W    = %{ $self->{root} };
    my %RET  = ();
    return () if ( !@_ );
    for (@_) {
        confess "The project $_ is not part of the Workspace $self->{DIR}"
          if ( !exists $W{$_} && $self->opt('error_not_found') );
    }
    @RET{@_} = ();
    my @UP = $self->_drillUp( [], keys %RET );
    @RET{@UP} = ();
    ## get TopMost (EAR)
    my %EAR = ();
    do { $EAR{$_} = () if exists $W{$_}{EAR} }
      for ( keys %RET );
    ## drillDown EAR for full EAR project
    for my $ear ( keys %EAR ) {
        my @DN = $self->_drillDown( [], $ear );
        @RET{@DN} = ();
    }
    return keys %RET;
}

=head2 _drillUp

Recursive function to search for parent projects

=cut

sub _drillUp {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my %RET  = ();
    @RET{ @{ shift() } } = ();
    return () if ( !@_ );
    @RET{@_} = ();
    my @PAR   = $self->getParents(@_);
    my %RESTO = ();
    do { $RESTO{$_} = () if ( !exists $RET{$_} ) }

      for (@PAR);    ## lo que queda por buscar
    if ( !@PAR || !keys(%RESTO) ) {    # agotado
        @RET{@PAR} = ();
        return keys %RET;
    }
    else {                             # drillUp
        my @UP = $self->_drillUp( [ keys %RET ], keys %RESTO );
        @RET{@UP} = ();
        return keys %RET;
    }
}

=head2 _drillUp

Recursive function to search for child projects

=cut

sub _drillDown {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my %RET  = ();
    @RET{ @{ shift() } } = ();
    return () if ( !@_ );
    @RET{@_} = ();
    my @CHI   = $self->getChildren(@_);
    my %RESTO = ();
    do { $RESTO{$_} = () if ( !exists $RET{$_} ) }

      for (@CHI);    ## list of remaining projects to search for
    if ( !@CHI || !keys(%RESTO) ) {    # agotado
        @RET{@CHI} = ();
        return keys %RET;
    }
    else {                             # drillDown
        my @UP = $self->_drillDown( [ keys %RET ], keys %RESTO );
        @RET{@UP} = ();
        return keys %RET;
    }
}

=head2 getChildren

Returns all dependent projects for a given prj or list, project + classpath

=cut

sub getChildren {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my @DEPS = ();
    my %RET  = ();
    push @DEPS, $self->verifyClasspathJ2EE(@_);
    push @DEPS, $self->verifyDepJ2EE(@_);
    ##TODO: un EAR además tiene sus modulemaps...
    @RET{@DEPS} = ();
    return keys %RET;
}

=head2 getParents

Returns all projects that dependes of a project or list

=cut

sub getParents {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my %RET  = ();
    for my $prj ( sort keys %W ) {
        my %CHILDREN;
        @CHILDREN{ $self->getChildren($prj) } = ();

        #print "*** $prj: CHI=".join(",",keys %CHILDREN);
        do { $RET{$prj} = () if ( exists $CHILDREN{$_} ) }
          foreach (@_);
    }
    return keys %RET;
}

=head2 orderWorkspace

Returns a list of graph-ordered projects.

=cut

sub orderWorkspace {
    my $self = shift();
    my %W    = %{ $self->{root} };

    use Graph;
    ## first, attempt a global ordered list; if errors on cyclic deps, I'll try a class ordered list
    try {
        my $g = new Graph;
        for my $prj ( @_ or keys %W ) {
            $g->add_vertex($prj);
            $g->add_edge( $prj, $_ ) foreach ( $self->getChildren($prj) );
        }
        ## graph order
        return reverse $g->topological_sort();
    }
    otherwise {
        ## dont care, change strategy
      }

      ## a graph, class by class, since usually the list will be LIB => EJB => WEB => EAR
      my @SORTED = ();
    my %PROJECTS = ();
    @PROJECTS{@_} = ();
    my $g = new Graph;
    for my $class (qw(LIB EJB WEB EAR)) {
        my $g = new Graph;
        for my $prj ( _unique( $self->getProjectsByClass($class) ) ) {
            next if ( %PROJECTS and !exists $PROJECTS{$prj} );
            $g->add_vertex($prj);
            foreach ( $self->getChildren($prj) )
            { ## children only; parents will yield duplicate edges; getParent uses getChildren
                $g->add_edge( $prj, $_ ) if $self->isClass( $_, $class );
            }
        }
        ## graph reverse order; if cyclic edges, just an alphabetical order
        push @SORTED, $g->is_cyclic
          ? sort $self->getProjectsByClass($class)
          : reverse $g->topological_sort( empty_if_cyclic => 1 );
    }
    return @SORTED;
}

=head2 getBuildXML

Generates an ANT build.xml file and returns a XML::Smart object.

=cut

sub getBuildXML {
    my $self = shift();
    my %W    = %{ $self->{root} };
    my %P    = @_;

    ## PREP
    delete $self->{output};
    delete $self->{build};
    delete $self->{build}{classpath};
    delete $self->{build}{classpathfileset};
    delete $self->{build}{classpathlibs};
    delete $self->{build}{target};
    $P{divide} = qq{<echo>} . ( '*' x 60 ) . qq{</echo>\n}
      if !exists $P{divide};
    $P{doc}      = 1        if !exists $P{doc};
    $P{cleanall} = 1        if !exists $P{cleanall};
    $P{mode}     = "SINGLE" if !exists $P{mode};
    $P{defaulttask} = 'all'
      if !exists $P{defaulttask};    ## default task on <project> tag
    $P{static_file_type} ||= 'zip';  ## could be 'tar' also

    ## ear, jar, war excludes, includes
    $P{exclude}     = '' if !exists $P{exclude};
    $P{ear_exclude} = '' if !exists $P{ear_exclude};
    $P{war_exclude} = '' if !exists $P{war_exclude};
    $P{jar_exclude} = '' if !exists $P{jar_exclude};
    $P{tar_exclude} = '' if !exists $P{tar_exclude};
    $P{ear_include} = '' if !exists $P{ear_include};
    $P{war_include} = '' if !exists $P{war_include};
    $P{jar_include} = '' if !exists $P{jar_include};
    $P{tar_include} = '' if !exists $P{tar_include};
    $P{static_exclude} = '';
    $P{static_include} = '';

    ## static_ext: non-dynamic comma separated file extentions
    if ( $P{static_ext} ) {
        foreach (
            ref( $P{static_ext} ) eq 'ARRAY' ? @{ $P{static_ext} } : split /,/,
            $P{static_ext}
          )
        {
            ## if it starts with a minus sign, its a dynamic ext instead of static
            my $key1 = ( m/^\-/ ? "static_include" : "static_exclude" );
            my $key2 = ( m/^\-/ ? "static_exclude" : "static_include" );
            s/^\-//;
            $P{$key1} .= qq{
                                                                                <exclude name="**/*.$_" />                                                      
                                                                     };
            $P{$key2} .= qq{
                                                                                <include name="**/*.$_" />                                                       
                                                                     };
        }
    }
    if ( $P{dynamic_ext} ) {
        foreach (
            ref( $P{dynamic_ext} ) eq 'ARRAY'
            ? @{ $P{dynamic_ext} }
            : split /,/,
            $P{dynamic_ext}
          )
        {
            ## if it starts with a minus sign, its a static ext instead of dynamic
            my $key1 = ( m/^\-/ ? "static_exclude" : "static_include" );
            my $key2 = ( m/^\-/ ? "static_include" : "static_exclude" );
            s/^\-//;
            $P{$key1} .= qq{
                                                                                <exclude name="**/*.$_" />                                                      
                                                                     };
            $P{$key2} .= qq{
                                                                                <include name="**/*.$_" />                                                       
                                                                     };
        }
    }
    my @PROJECTS = ();

          $P{projects}
      and $self->opt('error_not_found')
      and !$self->isa_project( @{ $P{projects} } )
      and croak "Project not found $@";
    $P{projects} and @PROJECTS = $self->valid( @{ $P{projects} } );

    $P{javac_opts} = "" if !exists $P{javac_opts};
    $P{delete_opts} = 'failonerror="false"' if !exists $P{delete_opts};

    ## User provided Classpath
    my $opt_classpath = (
        ref $P{classpath} eq 'ARRAY'
        ? join ';',
        @{ $P{classpath} }
        : $P{classpath}
    );

    if ( $P{mode} =~ /SINGLE/i ) {
        $P{group} = "common";
        ## JAVAC
        $self->getJavacXML( {%P}, @PROJECTS, $self->getChildren(@PROJECTS) );
        ## JAR MODULES
        $self->getJarXML( {%P}, @PROJECTS );
        ## WAR MODULES
        $self->getWarXML( {%P}, @PROJECTS );
        ## CLASSPATH
        $self->getClasspathXML( $P{group}, $opt_classpath );
    }
    elsif ( $P{mode} =~ /DEPS/i ) {
        $P{group} = "common";
        ## JAVAC
        $self->getJavacXML( {%P}, @PROJECTS, $self->getChildren(@PROJECTS) );
        ## JAR MODULES
        $self->getJarXML( {%P}, @PROJECTS, $self->getChildren(@PROJECTS) );
        ## WAR MODULES
        $self->getWarXML( {%P}, @PROJECTS, $self->getChildren(@PROJECTS) );
        ## CLASSPATH
        $self->getClasspathXML( $P{group}, $opt_classpath );
    }
    elsif ( $P{mode} =~ /EAR/i ) {
        my @EAR = (
            ref $P{ear}
            ? @{ $P{ear} }
            : $self->getRelatedProjectsByClass( 'EAR', @PROJECTS ) );
        for my $earprj (@EAR) {
            my $group = $P{group} = $earprj;
            delete $self->{build}{classpathfileset}{$group};
            delete $self->{build}{classpathlibs}{$group};
            ## JAVAC
            $self->getJavacXML( { earprj => $earprj, %P },
                $self->getChildren($earprj) );
            $self->{build}{target}{package}{$group} .= qq{
                                             $P{divide}
                                             <echo>Enterprise Project $earprj</echo>
                                              $P{divide}
                                 } if $P{doc};
            my $earhome = $earprj . "/"
              . ( $W{$earprj}{earcontent} or "" )
              ;    ## this is where packaged objects should end
            $earhome =~ s{//}{/}g;
            ## JAR MODULES
            $self->getJarXML(
                { %P, path => $earhome },
                keys %{ $W{$earprj}{JARMODULES} },
                keys %{ $W{$earprj}{EJBMODULES} }
            );
            ## WAR MODULES
            $self->getWarXML( { %P, path => $earhome, earprj => $earprj },
                $self->getWarsFromEAR($earprj) );
            ## EAR Libs Classpath
            $self->{build}{classpathfileset}{$group}{"$earhome/lib"} = 1
              if -e $self->{DIR} . "/$earhome/lib";
            ## EAR
            my $earfile        = $W{$earprj}{deployName} . ".ear";
            my $applicationxml = $W{$earprj}{"application.xml"}{relpath};
            $self->{build}{target}{clean}{$group} .= qq{        
                                             <delete file="$earfile" $P{delete_opts} />
                                 };
            $self->{build}{target}{package}{$group} .= qq{
                                             <ear destfile="$earfile" 
                                                         appxml="$applicationxml">

                                               <fileset dir="$earhome" >
                                                         <exclude name=".*" />
                                                         <exclude name="**/*.java" />
                                                         
                                                         $P{exclude}
                                                         $P{ear_exclude}
                                                         $P{ear_include}

                                               </fileset>

                                             </ear>

                                 };
            push @{ $self->{output} },
              { file => "$earfile", class => $earprj, ext => 'EAR' };
            $self->getClasspathXML( $group, $opt_classpath );
        }    ##@EAR
    }
    ###############################################
    ## BUILD.XML layout
    my $RET .= qq{
                      <?xml version="1.0" encoding="utf-8"?>
                      <project name="SCM" default="$P{defaulttask}" basedir=".">
          };
    ## CLASSPATH
    $RET .= qq{
                                 $self->{build}{classpath}{$_}
          } foreach keys %{ $self->{build}{classpath} };
    ## TARGETS
    my %ALL;
    my %ALLGROUPS;
    foreach my $target ( 'clean', 'build', 'package' )
    {    ## could be also sort keys %{ $self->{build}{target} }
        foreach my $group ( sort keys %{ $self->{build}{target}{$target} } ) {
            $ALLGROUPS{$group} = ();
            my $targetname = "${target}_${group}";
            $ALL{$target}{$targetname} = ();
            $RET .= qq{
                                             <target name="$targetname">
                                                                     $self->{build}{target}{$target}{$group}
                                             </target>
                                 };
        }
    }
    ## CLOSURE
    my $allclean   = join( ',', sort keys( %{ $ALL{clean} } ) );
    my $allbuild   = join( ',', keys( %{ $ALL{build} } ) );
    my $allpackage = join( ',', keys( %{ $ALL{package} } ) );
    my $callclean  = "";
    $callclean .= qq{<antcall target="$_" />}
      foreach sort keys( %{ $ALL{clean} } );
    my $callbuild = "";
    $callbuild .= qq{<antcall target="$_" />}
      foreach sort keys( %{ $ALL{build} } );
    my $callpackage = "";
    $callpackage .= qq{<antcall target="$_" />}
      foreach sort keys( %{ $ALL{package} } );
    my $callgroups = "";

    foreach my $group ( sort keys %ALLGROUPS ) {
        $callgroups .= qq{<antcall target="${_}_$group" />}
          foreach ( 'clean', 'build', 'package' );
    }
    $RET .= qq{
                                 <target name="clean">
                                             <echo>Running all cleanup targets: $allclean</echo>
                                             $callclean
                                 </target>
                                 <target name="build">
                                             <echo>Running all build targets: $allbuild</echo>
                                             $callbuild
                                 </target>
                                 <target name="package">
                                             <echo>Running all package targets: $allpackage</echo>
                                             $callpackage
                                 </target>
                                 <target name="all">
                                             <echo>Running all targets by group</echo>
                                             $callgroups
                                 </target>
                                 
                      </project>
          };

    ## TIDY UP XML
    $RET =~ s{\n\n*}{\n}sg;
    $RET =~ s{\n\t*\n}{\n}sg;
    $RET =~ s{//}{/}sg;
    $RET =~ s{^\n\n*}{}s;
    $RET =~ s{^\t*}{}s;
    ## this is the real tidying!
    my $buildXML = ();
    try {
        $buildXML = XML::Smart->new($RET);
        $self->{build}{xml} = $buildXML if ($buildXML);
        return $buildXML;
    }
    otherwise {
        my $filename = "xml_error_$$.xml";
        open FF, ">", $filename;
        print FF $RET;
        close FF;
        $self->{build}{xmlerror} = $RET;
        confess _loc(
"Error while parsing generated build.xml (please, check file %1 to see the invalid file):%2",
            $filename, shift
        );
    };
}

=head2 getJavacXML

Returns the XML snippet for compiling all sourceable locations.

=cut

sub getJavacXML {
    my $self = shift;
    my %W    = %{ $self->{root} };
    my %P    = %{ shift() };

    my $group = ( $P{group} or 'common' );

    ## only unique projects
    for my $prj ( $self->orderWorkspace( _unique(@_) ) ) {
        next if !exists $W{$prj}{SRC};
        if ( !ref $W{$prj}{OUTPUT} ) {
            confess _loc(
qq{Error while trying to define the compile strategy for project %1:\nMissing .classpath 'output' entry, such as:\n\t<classpathentry kind="output" path="WebContent/WEB-INF/classes"/>\n},
                $prj
            );
        }
        my ($outputhome) = @{ $W{$prj}{OUTPUT} } or next;
        $self->{build}{target}{build}{$group} .= qq{
                                             $P{divide}
                                             <echo>Compiling $prj</echo>
                      };
        $self->{build}{target}{build}{$group} .= qq{
                                 <mkdir dir="$prj/$_"/>  
                      } foreach ( @{ $W{$prj}{SRC} } );

        $self->{build}{target}{build}{$group} .= qq{
                                 <mkdir dir="$prj/$outputhome"/> 
                                 <javac destdir="$prj/$outputhome" $P{javac_opts} >
                                             <classpath refid="classpath_$group"/>
                      };

        ##MODIFICACIONES POPULAR OSCAR
        $self->{build}{target}{build}{$group} .= qq{
                                 <classpath>
                      };

        $self->{build}{target}{build}{$group} .= qq{
                                             <fileset dir="$prj$W{$prj}{webcontent}/WEB-INF/lib">
                                                         <include name="**/*.jar"/>
                                             </fileset>
                      }
          if ( -d "$self->{realpath}/$prj$W{$prj}{webcontent}/WEB-INF/lib" );

        if ( -d "$self->{realpath}/$prj$W{$prj}{webcontent}/WEB-INF/lib" ) {
            print
"EXISTE: $self->{realpath}/$prj$W{$prj}{webcontent}/WEB-INF/lib\n";
        }
        else {
            print
"NO EXISTE: $self->{realpath}/$prj$W{$prj}{webcontent}/WEB-INF/lib\n";
        }

        $self->{build}{target}{build}{$group} .= qq{
                                             <fileset dir="/usr/lpp/WAS6/WebSphere/AppServer/lib">
                                                         <include name="**/*.jar"/>
                                             </fileset>
                                 </classpath>
                      };
        ##END MODIFICACIONES

        $self->{build}{classpathlibs}{"$prj/$outputhome"} = ();

        ## .classpath libs
        if ( ref $W{$prj}{classpath}{lib} ) {
            foreach ( @{ $W{$prj}{classpath}{lib} } ) {
                $self->{build}{classpathlibs}{$group}{$_} = ();
            }
        }
        ## MANIFEST.MF Class-Path libs
        if ( ref $W{$prj}{classpath}{manifestlib} && $P{earprj} ) {
            foreach ( @{ $W{$prj}{classpath}{manifestlib} } ) {
                $self->{build}{classpathlibs}{$group}{"$P{earprj}/$_"} = ();
            }
        }

        $self->{build}{target}{build}{$group} .= qq{
                                             <src path="$prj/$_" />
                      } foreach ( @{ $W{$prj}{SRC} } );

        $self->{build}{target}{build}{$group} .= qq{
                                 </javac>
                      };
        ## also take property files, etc
        $self->{build}{target}{build}{$group} .= qq{
                                 <copy todir="$prj/$outputhome">
                      };
        $self->{build}{target}{build}{$group} .= qq{
                                             <fileset dir="$prj/$_">
                                                         <exclude name="**/*.java"/>
                                             </fileset>
                      } foreach ( @{ $W{$prj}{SRC} } );
        $self->{build}{target}{build}{$group} .= qq{
                                 </copy>           
                      };
        ## clean
        $self->{build}{target}{clean}{$group} .= qq{        
                                 <delete $P{delete_opts} >
                                             <fileset dir="$prj/$outputhome" includes="**/*.class" />
                                 </delete>
                      } if ( $P{cleanall} );
    }

}

=head2 getClasspathXML

Creates the classpath portion of the final file

=cut

sub getClasspathXML {
    my $self      = shift();
    my $group     = shift();
    my $classpath = shift();

    ##OPEN
    $self->{build}{classpath}{$group} .= qq{ <path id="classpath_$group"> };

    if ($classpath) {
        for ( split /\n|\;/, $classpath ) {
            s/\n|\r|\;//g;
            if (/\.jar$/i) {
                $self->{build}{classpathlibs}{$group}{$_} = ();
            }
            else {
                $self->{build}{classpath}{$group} .= qq{
                                                         <fileset dir="$_">
                                                                     <include name="**/*.jar"/>
                                                         </fileset>
                                             };
            }
        }
    }
    ## CLASSPATH - finishup with unique entries
    $self->{build}{classpath}{$group} .= qq{
                                 <fileset dir="$_">
                                             <include name="**/*.jar"/>
                                 </fileset>
          } foreach sort keys %{ $self->{build}{classpathfileset}{$group} };
    $self->{build}{classpath}{$group} .= qq{
                      <pathelement location="$_" />
          } foreach sort keys %{ $self->{build}{classpathlibs}{$group} };
    ##CLOSE
    $self->{build}{classpath}{$group} .= qq{ </path> };

}

=head2 getJarXML

Returns the XML snippet for packaging JARs

=cut

sub getJarXML {
    my $self = shift;
    my %W    = %{ $self->{root} };
    my %P    = %{ shift() };
    ( my $path = ( $P{path} or "." ) ) =~
      s{//}{/}g;    ## where to leave my jar files

    my $group = ( $P{group} or 'common' );

    for my $jarprj (@_) {
        next if !exists $W{$jarprj}{JAR};
        if ( !ref $W{$jarprj}{OUTPUT} ) {
            confess _loc(
qq{Error while trying to define the compile strategy for project %1:\nMissing .classpath 'output' entry, such as:\n\t<classpathentry kind="output" path="WebContent/WEB-INF/classes"/>\n},
                $jarprj
            );
        }
        my ($outputhome) = @{ $W{$jarprj}{OUTPUT} } or next;
        my $jarfile = (
            exists $W{$jarprj}{EJB}
            ? (
                exists $W{$jarprj}{weburi}
                ? $W{$jarprj}{weburi}
                : "$jarprj.jar"
              )
            : (
                exists $W{$jarprj}{uri}
                ? $W{$jarprj}{uri}
                : "$jarprj.jar"
            )
        );
        $self->{build}{clean}{$group} .= qq{       
                                 <delete file="$path/$jarfile" $P{delete_opts} />
                      };
        my $prjtype = ( exists $W{$jarprj}{EJB} ? "EJB" : "Java Utility" );
        $self->{build}{target}{package}{$group} .= qq{
                                 <echo>$prjtype Project $jarprj</echo>
                      } if $P{doc};
        $self->{build}{target}{package}{$group} .= qq{
                                 <jar destfile="$path/$jarfile" }
          . (
            !$W{$jarprj}{"MANIFEST.MF"}
            ? ""
            : qq{ manifest="$jarprj/$outputhome/META-INF/MANIFEST.MF" }
          )
          . qq{ 
                                             >
                                             <fileset dir="$jarprj/$outputhome" >

                                                         $P{jar_include}

                                                         $P{exclude}
                                                         $P{jar_exclude}

                                                         <exclude name=".*" />
                                                         <exclude name="**/*.java" />
                                             </fileset>
                                 </jar>
                      };
        push @{ $self->{output} },
          { file => "$path/$jarfile", class => $jarprj, ext => 'JAR' };
    }
}

=head2 getWarXML

Returns the XML snippet for packaging WARs

=cut

sub getWarXML {
    my $self = shift;
    my %W    = %{ $self->{root} };
    my %P    = %{ shift() };
    ( my $path = ( $P{path} or "." ) ) =~ s{//}{/}g;

    my $group = ( $P{group} or 'common' );
    for my $warprj (@_) {
        next if !exists $W{$warprj}{WAR};
        my $warfile =
            $P{earprj}
          ? $W{ $P{earprj} }{WARMODULES}{$warprj}{weburi}
          : $W{$warprj}{weburi};
        my $webcontenthome = (
            exists $W{$warprj}{webcontent}
            ? "" . $W{$warprj}{webcontent}
            : "" );
        my $deploypath =
          $W{$warprj}
          {deployPath};    ## assumes there's only one deployPath - may be wrong
        my $classeshome = $W{$warprj}{property}{"java-output-path"};
        $self->{build}{clean}{$group} .= qq{       
                                 <delete file="$path/$warfile" $P{delete_opts} />
                      };
        $self->{build}{target}{package}{$group} .= qq{    
                                 <echo>Web Application $warprj</echo>
                      } if $P{doc};

        #Cambiado por OSCAR
        #$self->{build}{target}{package}{$group} .= qq{
        #          <copy todir="$warprj/$webcontenthome/$deploypath">
        #                      <fileset dir="$warprj/$classeshome" />
        #          </copy>
        #} if $classeshome;
        $self->{build}{target}{package}{$group} .= qq{    
                                 <war destfile="$path/$warfile"
                                             webxml="$warprj/$webcontenthome/WEB-INF/web.xml" }
          . (
            !$W{$warprj}{"MANIFEST.MF"}{relpath}
            ? ""
            : qq{ manifest="$W{$warprj}{'MANIFEST.MF'}{relpath}" }
          )
          . qq{ 
                                             >
                                             <fileset dir="$warprj/$webcontenthome">

                                                         $P{war_include}                                                           

                                                         <exclude name="**/web.xml" />
                                                         <exclude name="**/*.java" />                                                   
                                                         $P{exclude}
                                                         $P{war_exclude}                                                          
                                                         $P{static_exclude}
                                                         
                                             </fileset>
                                 </war>
                      };
        push @{ $self->{output} },
          { file => "$path/$warfile", class => $warprj, ext => 'WAR' };
        if ( $P{static_include} ) {

            my $htpfile = $warfile;
            $htpfile =~ s/\..*$//g;
            $htpfile .= ".tar";
            $self->{build}{target}{clean}{$group} .= qq{        
                                             <delete file="$htpfile" $P{delete_opts} />
                                 };
            $self->{build}{target}{package}{$group} .= qq{
                                                         <$P{static_file_type} destfile="$htpfile">
                                                                     <$P{static_file_type}fileset dir="$warprj/$webcontenthome">
                                                                                
                                                                                $P{static_include}                                                                    
                                                                                $P{tar_include}                                                                        

                                                                                $P{exclude}                                                                             
                                                                                $P{tar_exclude}                                                                       
                                                                                
                                                                     </$P{static_file_type}fileset>
                                                         </$P{static_file_type}>
                                 };
            push @{ $self->{output} },
              { file => "$htpfile", class => $warprj, ext => 'TAR' };
        }
    }

}

=head2 parse

Populates the project datastructure with parsed information from the j2EE Eclipse Workspace.

=head3 arguments

          my $wks = BaselinerX::Eclipse::J2EE->parse ( 
                      workspace=> q{ /home/user/workspace }, 
                      check_deps=>0, error_not_found=>0 );
                      
=over

=head4 workspace

The Eclipse workspace dir to parse.

=head4 check_deps (bool)

If true, croaks whenever project dependencies are not found in the workspace.

Default=True

=head4 error_not_found (bool)

If true, croaks if projects sent as arguments are not in the workspace or are not valid (ie. do not have a .project file)

Default=False

=cut

sub parse {
    my $self = shift;
    if ( !ref $self ) {
        my $class = $self;
        $self = $class->new(@_);
        $self = bless( $self, 'BaselinerX::Eclipse::J2EE' );
        $self->parse();
        return $self;
    }
    my %W = %{ $self->{root} };
    for my $prj ( sort keys %W ) {
        ## Is it JAVA
        next if ( !exists $W{$prj}{".project"}{xml} );
        for my $nat ( ${ $W{$prj}{".project"}{xml} }
            ->{projectDescription}{natures}{nature}('@') )
        {
            $W{$prj}{JAVA} = $nat if ( $nat =~ /javanature/ );
            $W{$prj}{WEB}  = $nat if ( $nat =~ /WebNature/ );       ##solo RAD6
            $W{$prj}{EAR}  = $nat if ( $nat =~ /\.EAR.*Nature/ );   ##solo RAD6
            $W{$prj}{EJB}  = $nat if ( $nat =~ /\.EJB.*Nature/ );   ##solo RAD6?
            $W{$prj}{EMF}  = $nat if ( $nat =~ /\.JavaEMFNature/ ); ## RAD6 y 7
            ##TODO: EJBClient? no specific nature
            ##TODO: here's a  good place to throw away projects that arent javanature (perl, sql, etc.)
        }
        ## RAD version?
        $W{$prj}{RAD} = ( exists $W{$prj}{".modulemaps"} ? 6 : 7 );
        ## Es WEB?
        if ( exists $W{$prj}{".classpath"}{xml} ) {  ##! exists $W{$prj}{WEB} &&
            ## classpath list
            for ( ${ $W{$prj}{".classpath"}{xml} }
                ->{classpath}{classpathentry}( 'kind', 'eq', 'lib' ) )
            {
                push @{ $W{$prj}{classpath}{lib} },
                  (
                      $_->{path} =~ m{^/(.*)}
                    ? $1
                    : $prj . "/" . $_->{path}
                  );
            }
            ## also tells me if I'm a WEB project
            for ( ${ $W{$prj}{".classpath"}{xml} }
                ->{classpath}{classpathentry}( 'kind', 'eq', 'con' ) )
            {
                if ( $_->{path} eq
                    'org.eclipse.jst.j2ee.internal.web.container' )
                {
                    $W{$prj}{WEB} =
                      'org.eclipse.jst.j2ee.internal.web.container';
                    last;
                }
            }
        }
        ## WEB settings
        if ( exists $W{$prj}{".websettings"}{xml} ) {
            my $XML = ${ $W{$prj}{".websettings"}{xml} };
            $W{$prj}{webcontent}     = $XML->{websettings}{webcontent};
            $W{$prj}{"context-root"} = $XML->{websettings}{"context-root"};
            $W{$prj}{"project-type"} = $XML->{websettings}{"project-type"};
            $W{$prj}{"jsp-level"}    = $XML->{websettings}{"jsp-level"};
        }
        ## Project Name
        $W{$prj}{projectName} =
          ${ $W{$prj}{".project"}{xml} }->{projectDescription}{name};
        ## RAD7: facet discovery
        if (
            exists $W{$prj}{"org.eclipse.wst.common.project.facet.core.xml"}
            {xml} )
        {
            for (
                ${
                    $W{$prj}{"org.eclipse.wst.common.project.facet.core.xml"}
                      {xml}
                }->{"faceted-project"}{"fixed"}('@')
              )
            {
                my $facet = $_->{"facet"};
                $W{$prj}{facet} = $facet if ($facet);
                $W{$prj}{EAR}   = $facet if ( $facet && $facet =~ m/\.ear/i );
                $W{$prj}{WEB}   = $facet if ( $facet && $facet =~ m/\.web/i );
                $W{$prj}{UTILITY} = $facet
                  if ( $facet && $facet =~ m/\.utility/i );
                $W{$prj}{EJB} = $facet if ( $facet && $facet =~ m/\.ejb/i );
                $W{$prj}{JAR} = $facet if ( $facet && $facet =~ m/\.java/i );
            }
        }
        ##
        ## WEB Modules RAD7
        ##
        if (   exists $W{$prj}{WEB}
            && exists $W{$prj}{"org.eclipse.wst.common.component"}{xml} )
        {
            my $XML = ${ $W{$prj}{"org.eclipse.wst.common.component"}{xml} };
            $W{$prj}{"deployName"} =
              $XML->{"project-modules"}{"wb-module"}{"deploy-name"};
            foreach (
                $XML->{"project-modules"}{"wb-module"}{"wb-resource"}('@') )
            {
                push @{ $W{$prj}{"src-deploy"} },
                  [ $_->{"source-path"}, $_->{"deploy-path"} ];
                $W{$prj}{webcontent} = $_->{"source-path"}
                  if $_->{"deploy-path"} eq "/";    ### it's WebContent
                $W{$prj}{deployPath} = $_->{"deploy-path"}
                  if $_->{"deploy-path"} =~ m/...*/;    ### it's a src
            }
            foreach ( $XML->{"project-modules"}{"wb-module"}{"property"}('@') )
            {
                $W{$prj}{property}{ $_->{name} } = $_->{value};
            }
        }
        ##
        ## EAR Modules
        ##
        if ( exists $W{$prj}{EAR} ) {
            if ( $W{$prj}{RAD} eq 7 ) {                 ## RAD7
                my (%MODULE) = ();
                ##-------- org.eclipse.wst.common.component
                if ( exists $W{$prj}{"org.eclipse.wst.common.component"}{xml} )
                {
                    my $XML =
                      ${ $W{$prj}{"org.eclipse.wst.common.component"}{xml} };
                    $W{$prj}{"deployName"} =
                      $XML->{"project-modules"}{"wb-module"}{"deploy-name"};
                    foreach (
                        $XML->{"project-modules"}{"wb-module"}{"wb-resource"}(
                            '@') )
                    {
                        $W{$prj}{"deployPath"} = $_->{"deploy-path"};
                        $W{$prj}{"sourcePath"} = $_->{"source-path"};
                        $W{$prj}{"earcontent"} = $_->{"source-path"}
                          if $_->{"deploy-path"} eq "/";    ### it's EarContent
                    }
                    foreach
                      my $depModule ( $XML->{"project-modules"}{"wb-module"}
                        {"dependent-module"}('[@]') )
                    {
                        $depModule->{handle} =~ m{^module\:/resource/.*?/(.*)$};
                        my $projectName = $1;
                        if ( $depModule->{archiveName} ) {
                            $W{$prj}{JARMODULES}{$projectName}{"uri"} =
                              $depModule->{archiveName};
                            $W{$projectName}{"uri"} = $depModule->{archiveName};
                        }
                        else {
                            my $id = $depModule->{"dependent-object"};
                            my $type =
                              $depModule->{"dependency-type"};   ## no utilizado
                            $MODULE{$id}{projectName} = $projectName;
                        }
                    }
                }
                ##-------- application.xml
                if ( exists $W{$prj}{"application.xml"}{xml} ) {
                    my $XML         = ${ $W{$prj}{"application.xml"}{xml} };
                    my $displayName = $XML->{application}{'display-name'};
                    my @APPMODULES  = $XML->{application}{module}('[@]');
                    foreach my $module (@APPMODULES) {
                        my $id = $module->{id};
                        if ( $module->{ejb} ) {
                            $MODULE{$id}{class}  = "ejb";
                            $MODULE{$id}{ejb}    = 1;
                            $MODULE{$id}{weburi} = $module->{ejb};
                        }
                        if ( $module->{web} ) {
                            $MODULE{$id}{class}  = "web";
                            $MODULE{$id}{web}    = 1;
                            $MODULE{$id}{weburi} = $module->{web}{'web-uri'};
                            $MODULE{$id}{context} =
                              $module->{web}{'context-root'};
                        }
                    }
                }
                ##--------  WARS, EJBS
                foreach my $id ( keys %MODULE ) {
                    if ( $MODULE{$id}{class} eq "web" ) {
                        my $projectName = $MODULE{$id}{projectName};
                        $W{$prj}{WARMODULES}{$projectName}{"weburi"} =
                          $MODULE{$id}{weburi};
                        $W{$prj}{WARMODULES}{$projectName}{"context"} =
                          $MODULE{$id}{context};
                        $W{ $MODULE{$id}{projectName} }{WEB} =
                          1;    ## es un proyecto WEB
                        $W{ $MODULE{$id}{projectName} }{"weburi"} =
                          $MODULE{$id}{weburi};
                    }
                    elsif ( $MODULE{$id}{class} eq "ejb" ) {
                        my $projectName = $MODULE{$id}{projectName};
                        $W{$prj}{EJBMODULES}{$projectName}{"weburi"} =
                          $MODULE{$id}{weburi};
                        $W{ $MODULE{$id}{projectName} }{JAR} =
                          1;    ## es un proyecto JAR
                        $W{ $MODULE{$id}{projectName} }{EJB} =
                          1;    ## es un proyecto JAR
                        $W{ $MODULE{$id}{projectName} }{"weburi"} =
                          $MODULE{$id}{weburi};
                    }
                    else {
                        warn _loc( "Module type unknown: %1",
                            $MODULE{$id}{class} );
                    }
                    ##print uc($MODULE{$id}{class})." $MODULE{$id}{projectName} => $MODULE{$id}{weburi},$MODULE{$id}{context}\n";
                }
            }
            else {              ## RAD6
                my (%MODULE) = ();
                ##-------- application.xml
                if ( my $XML = ${ $W{$prj}{"application.xml"}{xml} } ) {
                    my $displayName = $XML->{"application"}{'display-name'};
                    $displayName =~ s/ *|\n|\t//g;
                    $W{$prj}{"deployName"} = $displayName;
                    my @APPMODULES = $XML->{"application"}{"module"}('@');
                    foreach my $module (@APPMODULES) {
                        my $id = $module->{id};
                        if ( exists $module->{ejb} ) {
                            $MODULE{$id}{class}  = "EJB";
                            $MODULE{$id}{ejb}    = 1;
                            $MODULE{$id}{weburi} = $module->{ejb};
                        }
                        if ( exists $module->{web} ) {
                            $MODULE{$id}{class}  = "WEB";
                            $MODULE{$id}{web}    = 1;
                            $MODULE{$id}{weburi} = $module->{web}{'web-uri'};
                            $MODULE{$id}{context} =
                              $module->{web}{'context-root'};
                        }
                    }
                }
                ##-------- .modulemaps
                if ( my $XML = ${ $W{$prj}{".modulemaps"}{xml} } ) {
                    for ( $XML->{"modulemap:EARProjectMap"}{"mappings"}('@') ) {
                        if ( $_->{"module"}{"xmi:type"} eq
                            "application:WebModule" )
                        {
                            my $id = $_->{"module"}{"href"};
                            $id =~ s{META-INF/application.xml\#}{}g;
                            $W{$prj}{WARMODULES}{ $_->{"projectName"} }
                              {"weburi"} = $MODULE{$id}{weburi};
                            $W{$prj}{WARMODULES}{ $_->{"projectName"} }
                              {"context"} = $MODULE{$id}{context};
                            $W{ $_->{"projectName"} }{WEB} =
                              1;    ## es un proyecto WEB
                            $W{ $_->{"projectName"} }{weburi} =
                              $MODULE{$id}{weburi};
                        }
                        elsif ( $_->{"module"}{"xmi:type"} eq
                            "application:EjbModule" )
                        {
                            my $id = $_->{"module"}{"href"};
                            $id =~ s{META-INF/application.xml\#}{}g;
                            $W{$prj}{EJBMODULES}{ $_->{"projectName"} }
                              {"weburi"} = $MODULE{$id}{weburi};
                            $W{ $_->{"projectName"} }{JAR} =
                              1;    ## es un proyecto JAR
                            $W{ $_->{"projectName"} }{"weburi"} =
                              $MODULE{$id}{weburi};
                        }
                    }
                    for (
                        $XML->{"modulemap:EARProjectMap"}{"utilityJARMappings"}(
                            '@') )
                    {
                        next if !$_->{"projectName"};
                        $W{$prj}{JARMODULES}{ $_->{"projectName"} }{"uri"} =
                          $_->{uri};
                        $W{ $_->{"projectName"} }{JAR} =
                          1;    ## es un proyecto JAR
                        $W{ $_->{"projectName"} }{"uri"} = $_->{uri};
                    }
                }
                ##-------- children (from .project) - sometimes .modulemaps will not point to utilities
                for my $depprj ( ${ $W{$prj}{".project"}{xml} }
                    ->{projectDescription}{projects}{project}('@') )
                {
                    if ( exists $W{$depprj}{JAR} ) {

#$W{$prj}{JARMODULES}{ $depprj } = exists $W{$depprj}{uri} ?  $W{$depprj}{uri} : "$depprj.jar" ;
                    }
                }
            }    ##if RADx
        }    ##if EAR
        if ( $W{$prj}{".classpath"}{xml} ) {
            for ( ${ $W{$prj}{".classpath"}{xml} }
                ->{classpath}{classpathentry}( 'kind', 'eq', 'src' ) )
            {
                next if ( exists $_->{exported} );    ## RAD6 externals
                next
                  if ( exists $_->{combineaccessrules} )
                  ;    ## RAD7 external projects; processed later
                push @{ $W{$prj}{SRC} }, $_->{path};
            }
            for ( ${ $W{$prj}{".classpath"}{xml} }
                ->{classpath}{classpathentry}( 'kind', 'eq', 'output' ) )
            {
                push @{ $W{$prj}{OUTPUT} }, $_->{path};
            }
        }
        ## DEACTIVATE false NATURE/FACET
        delete $W{$prj}{JAR}
          if exists $W{$prj}{WEB}; ## web prjs are JAR, but do not generate JARs
    }    ## for prj

    ## Post Processing
    for my $prj ( sort keys %W ) {
        ## CLASSPATH DEPENDENCIES  kind="src"
        if ( $W{$prj}{".classpath"}{xml} ) {
            for ( ${ $W{$prj}{".classpath"}{xml} }
                ->{classpath}{classpathentry}( 'kind', 'eq', 'src' ) )
            {
                if (
                    (
                        exists $_->{combineaccessrules}
                        or $_->{exported} eq 'true'
                    )
                    && $_->{path}
                  )
                {    ## RAD6 & 7 external projects
                    my $extprj = substr( $_->{path}, 1 );
                    push @{ $W{$prj}{classpath}{lib} },
                      map { $extprj . "/" . $_ } @{ $W{$extprj}{OUTPUT} }
                      if $extprj;
                }
            }
        }

        ## some jar prjs have properties set by its ear project
        $W{$prj}{LIB} = 1
          if ( exists $W{$prj}{JAR} && !exists $W{$prj}{EJB} )
          ;          ## los libs son jar, pero no ejb
    }
    do { $W{$_}{WAR} = 1 if exists $W{$_}{WEB} }
      for keys %W;
    do { $W{$_}{JAR} = 1 if exists $W{$_}{EJB} }
      for keys %W;

    ## MANIFEST.MF Class-Path: libs relative to EAR path
    for my $prj ( sort keys %W ) {
        if ( $W{$prj}{"MANIFEST.MF"} ) {
            my $data = $W{$prj}{"MANIFEST.MF"}{data};
            if ( $data =~ s/^.*class-path: (.*)/$1/si ) {
                $data =~ s/\r//gsi;    ## no ^M
                $data =~
                  s/\n\n.*$//si;    ## ignore everything after de double newline
                $data =~ s/\n//gsi; ## now newline is useless
                if ($data) {        ## could be a blank classpath
                    $data =~
                      s/  */ /gsi; ## multiple whitespaces to single whitespaces
                    ## my ear is this, but could be more than one:
                    ##       print $self->getEarProjects( $self->getRelatedProjects( $prj ) );
                    ## so it's better to resolve it later, at build.xml time
                    push @{ $W{$prj}{classpath}{manifestlib} }, split / /,
                      $data;
                }
            }
        }
    }
}

=head2 printAll

Prints a project list.

=cut

sub printAll {
    my $self = shift;
    my %W    = %{ $self->{root} };
    for my $prj ( sort keys %W ) {
        ## print details
        print "\n-------| " . $prj;
        print $_. " = " . $W{$prj}{$_} for ( keys %{ $W{$prj} } );
    }
}

sub verifyDepJ2EE {
    my $self    = shift;
    my %W       = %{ $self->{root} };
    my @LIST    = @_;
    my %DEPS    = ();
    my %DEPFAIL = ();
    for my $prj ( @LIST ? @LIST : sort keys %W )
    {    ## para todos los proyectos del workspace (o lista)
        ## Dep projs
        last if !$self->isa_project($prj);
        for my $depName ( ${ $W{$prj}{".project"}{xml} }
            ->{projectDescription}{projects}{project}('@') )
        {    ## para todos los proyectos del que depende
            my $satisfy = 0;
            for my $allprj ( $self->projects() ) {
                if ( $W{$allprj}{projectName} eq $depName ) {
                    $DEPS{$allprj} = 1;
                    $satisfy = 1;
                    last;
                }
            }
            $DEPFAIL{
                _loc(
"'$prj' project has a dependent project '$depName' missing from the workspace."
                )
              }
              = 1
              if ( !$satisfy && $self->opt('check_deps') );
        }
    }
    if ( keys %DEPFAIL ) {
        my $msg;
        $msg .= "$_\n" for ( keys %DEPFAIL );
        confess _loc( "verifyDepJ2EE: dependency error:\n%1", $msg );
    }
    return keys %DEPS;
}

=head2 verifyClasspathJ2EE

Returns a list of dependent projects extracted from the .classpath files, <src> tags.

=cut

sub verifyClasspathJ2EE {
    my $self    = shift;
    my %W       = %{ $self->{root} };
    my @LIST    = @_;
    my %DEPFAIL = ();
    my %DEPS    = ();
    for my $prj ( ( @LIST eq 0 ? sort keys %W : @LIST ) )
    {    ## para todos los proyectos del workspace (o lista)
        next if ( !exists $W{$prj}{".classpath"}{xml} );
        ## Dep projs
        for my $entry ( ${ $W{$prj}{".classpath"}{xml} }
            ->{classpath}{classpathentry}( 'kind', 'eq', 'src' ) )
        {    ## para todos los proyectos del que depende
            my $satisfy = 0;
            next
              if ( $entry->{path} !~ m{^/} )
              ; ## doesn't start with a /, means its an self referenced classpath: ignore
            my $depprj =
              substr( $entry->{path}, 1 );    ## quito la barra de inicio
            for my $allprj ( keys %W ) {      ## for all workspace prjs
                if ( $allprj eq $depprj ) {    ## compare folder names
                    $DEPS{$allprj} = 1;        ## yup, it's a dependency
                    $satisfy = 1;              ## no more searching
                    last;
                }
            }
            $DEPFAIL{
                _loc(
"Project '%1' has a dependent project '%2' in the classpath missing from the workspace.",
                    $prj,
                    $depprj
                )
              }
              = 1
              if ( !$satisfy && $self->opt('check_deps') );
        }
    }
    if ( keys %DEPFAIL ) {
        my $msg;
        $msg .= "$_\n" for ( keys %DEPFAIL );
        confess "verifyClasspathJ2EE: dependency error:\n$msg";
    }
    return keys %DEPS;
}

1;

__END__

=head1 NAME

Baseliner::Parse::Eclipse::J2EE - parse j2EE projects in an Eclipse Workspace and transform them into Ant build.xml.

=head1 SYNOPSIS

          ## create the object and load files
          my $Wks = Baseliner::Parse::Eclipse::J2EE->new('/anydir/workspace'); 
          
          ## figure out files and load it in memory
          $Wks->parse();
          
          ## or parse straight out 
          my $Wks = Baseliner::Parse::Eclipse::J2EE->parse('/anydir/workspace');           

          ## generate the build.xml data
          my $xml = $Wks->buildxml( 
                                 classpath => "/javadir/classes",
                                 javac_opts => 'source="1.4"'
                                 );          
          
          ## printing is believing
          print $xml->{data};
          
          ## save the file
          $xml->save('/dir/build.xml');
          
          ## call ant -f /dir/build.xml clean build package

=head1 DESCRIPTION

=head1 METHODS

=head2 buildxml

This method will generate a XML::Smart object with that represents the ANT build.xml file created. The following options are available (none is mandatory):

=head3 mode => (ear|deps|single) 

Selects the build.xml creation method to be used. By default, it will use 'single'.

=item single

Compiles only projects passed on the C<project> option. No dependencies will be compiled. No ear packaging will occur, only jars and wars may be created. 

          my $xml = $Wks->buildxml( 
                                 mode => 'deps'            
                                 );
=item deps

Compiles projects passed thru the C<project> option and its dependencies. 

          my $xml = $Wks->buildxml( 
                                 mode => 'deps'            
                                 );

=item ear

Finds the parent ear project for the projects passed thru the C<project> option and compiles all dependent projects contained in the ear. The output will be a .ear file. 

If a file is in multiple ear projects, the list of ear projects can be controlled by the 

          my $xml = $Wks->buildxml( 
                                 mode => 'ear'   
                                 );

=head3 projects

List of eclipse project names to be considered by the workspace J2EE parser. If no projects are given, all projects in the workspace will be considered for construction. 

This is useful for limiting the scope of the build, ie. using a list of modified projects originating from you version control system for production deployment.

          my $xml = $Wks->buildxml( 
                                 projects => ['projectEAR','projectWEB','projectlibs']
                                 );

=head1 COMPATIBILITY

Actually tested against j2EE workspaces projects created by the following versions:

- Rational Developer 6.0.0
- Eclipse 3.2.2

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
