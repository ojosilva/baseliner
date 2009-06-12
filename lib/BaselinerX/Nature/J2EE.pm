package BaselinerX::Nature::J2EE;
use Baseliner::Plug;
use Baseliner::Utils;
use BaselinerX::Eclipse;
use BaselinerX::Eclipse::J2EE;

register 'config.nature.j2ee.build' => {
          metadata=> [
                      { id=>'host', label=>'Host de staging', type=>'text' },
                      { id=>'user', label=>'Usuario', type=>'text' },
                      { id=>'was_lib', label=>'WAS lib', type=>'text', extjs=>{ height=>100 } },
                      { id=>'jdk', label=>'JDK', type=>'text' },
                      { id=>'static', label=>'Contenido estatico', type=>'text' },
          ]
};

register 'config.nature.j2ee.deploy' => {
          metadata=> [
                      { id=>'Host', label=>'Host de despliegue', type=>'text' },
                      { id=>'User', label=>'Usuario', type=>'text' },
                      { id=>'targetDir', label=>'Directorio destino(WAS)', type=>'text' },
                      { id=>'deployScript', label=>'Script de despliegue', type=>'text' },
          ]
};

register 'service.nature.j2ee.deploy' => {
          name => 'Configurar Deploys',
          config => 'config.nature.j2ee.deploy',   
          handler => sub {
                      my ( $self, $c )=@_;
                      my $s = BaselinerX::Comm::SSH->open( 'harvestdes' );
                      my ($rc, $ret ) = $s->execute('ls');
                      print "RC=$rc, RET=$ret\n";
          }           
};
register 'service.nature.j2ee.build' => {
          name => 'Configurar Builds',
          config => 'config.nature.j2ee.build',
          handler => sub {
                      my ( $self, $c )=@_;
                      my $path = "c:/TRABAJO"; # $c->stash{workspace}
                      my $Workspace = BaselinerX::Eclipse::J2EE->parse( workspace=>$path );
                      $Workspace->{realpath} = $path; #esta linea deberia ir dentro de la clase J2EE para poder parsear el classpath del WEB-CONFIG/lib
                      #my @PROYECTOS = qw/AppBPE/;  ## $c->stash->{job}->{subapls};
                      #$Workspace->cutToSubset( $Workspace->getRelatedProjects( @PROYECTOS ) ) ;  
                      my @EARS = $Workspace->getEarProjects();
                      my @WARS = $Workspace->getWebProjects();
                      my @EJBS = $Workspace->getEjbProjects();
                      warn "\nEARS=" . join ',', @EARS;
                      warn "\nWARS=" . join ',', @WARS;
                      warn "\nEJBS=" . join ',', @EJBS;
                      use YAML;
                      foreach my $earprj ( @EARS ) {
                                 warn "EARPRJ=$earprj";
                                 my @SUBAPL_PRJ = $Workspace->getChildren( $earprj );
                                 warn "Proyectos children del $earprj: ". join',',@SUBAPL_PRJ;
                                 my $buildxml = $Workspace->getBuildXML( 
                                                         mode=> 'ear',
                                                         # static_ext => [ qw/jpg gif html htm js css/ ],
                                                         # static_file_type => 'tar',                                                                    
                                                         ear => [ $earprj ],
                                                         projects => [ @SUBAPL_PRJ ],
                                 );
                                 warn "BUILDXML=" . $buildxml;
                                 #antBuild(\%Dist, $buildfileBaseliner, $earfile ,$subapl, "clean build package", $buildtype, @OUTPUT )
                                 $buildxml->save($path."\\build_$earprj.xml");
                                 
                                 my @OUTPUT = $Workspace->output();
                                 for( @OUTPUT ) {
                                             print "SALIDA=" . Dump $_;
                                 }
                      }
                      

                      #my $earfile = $Workspace->genfile($earprj);    
                      #my $buildfileBaseliner = "build_$subapl.xml";
                      #$buildxml->save($Dist{buildhome}."/".$buildfileBaseliner);
                      #loginfo "Fichero <b>build.xml</b> para la subaplicacion <b>$subapl</b> y los proyectos: <li>".(join '<li>',@SUBAPL_PRJ), $buildxml->data;
                      #loginfo "Ficheros que se generarán en la construcción de $earprj:<br><li>". join '<li>', $Workspace->genfiles();

                      ## BUILD
                      #my @OUTPUT = $Workspace->output();

                      
                      
          }
};
register 'menu.j2ee' => { label => 'J2EE' };
register 'menu.j2ee.build' => { label => 'Build', url_comp => '/j2ee/build', title=>'Build' };

BEGIN { extends 'Catalyst::Controller' }
use YAML;
use JavaScript::Dumper;
          
sub j2ee_build_json : Path('/j2ee/build/json') {
    my ( $self, $c ) = @_;
          my $p = $c->request->parameters;
          my $config = $c->registry->get( 'config.nature.j2ee.build' );
          #my @rows = $config->rows( query=> $p->{query}, sort_field=> $p->{'sort'}, dir=>$p->{dir}  );
          my $datos = $config->factory($c);
          warn "DATOS========" . Dump $datos;
          $c->stash->{json} = { success=>\1, data => $datos };    
          $c->forward('View::JSON');
}

sub j2ee_submit : Path('/j2ee/build/submit') {
          my ($self,$c)=@_;
          my $p = $c->req->params;
          my $config = $c->registry->get( 'config.nature.j2ee.build' );
          my $ret = $config->store( $c, data=>$p );
          if(  $ret ) {
                      $c->res->body( "true" );
          } else {
                      $c->res->body( "false" );
          }
}

sub j2ee_build : Path('/j2ee/build') {
    my ( $self, $c ) = @_;
    $c->languages( ['es'] );
          my $config = $c->registry->get( 'config.nature.j2ee.build' );
    $c->stash->{url_store} = '/j2ee/build/json';
    $c->stash->{url_submit} = '/j2ee/build/submit';
    #$c->stash->{url_add} = '/job/new';
    $c->stash->{title} = $c->localize('J2EE Build');
    #$c->stash->{columns} = js_dumper $config->grid_columns;
    $c->stash->{fields} = js_dumper $config->grid_fields;

    $c->stash->{data} = $config->formfu_elements;
    $c->stash->{template} = '/comp/formmetadata.mas';
}

1;
