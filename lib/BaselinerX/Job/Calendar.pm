package BaselinerX::Job::Calendar;
use Baseliner::Plug;
use Baseliner::Utils;
BEGIN { extends 'Catalyst::Controller' };

{
	package BaselinerX::Calendar::Window;
	use Moose;
	    has 'dia' => ( is=>'rw', isa=>'Str' );
	    has 'id' => ( is=>'rw', isa=>'Str' );
	    has 'tipo' => ( is=>'rw', isa=>'Str' );
	    has 'ini' => ( is=>'rw', isa=>'Str' );
	    has 'fin' => ( is=>'rw', isa=>'Str' );
	    has 'activa' => ( is=>'rw', isa=>'Str' );
	no Moose;
}

our @week = qw/MON TUE WED THU FRI SAT SUN/;

sub calendar : Path( '/calendar' ) {
	my ( $self, $c ) = @_;
	$c->stash->{windows} = new BaselinerX::Calendar::Window();
	$c->stash->{template} = '/comp/calendar.mas';
}

sub calendar_edit : Path( '/job/calendar_edit' ) {
	my ( $self, $c ) = @_;
	$c->stash->{template} = '/t/calendar_edit.mas';
}

=head 

	my $windows = $c->stash->{windows};  ## get the window object
	my ( $ctype, $lastctype, $active, $lastactive );
	my $lastid = -1;
	for my $dd ( 0..6 ) {
		my $row = 0;
		my $rowspan = 0;
		my $last_hour = "00:00";
		my $hour = "";
		for my $hh ( 0..23 ) {
			for ( my $mm=0; $mm<60; $mm+=30 ) {
				next if(  $hh>=24 && $mm>0 );
				my $hour = sprintf( "%02d:%02d", $hh, $mm );
				my $win = $windows->get( $dd, $hour );
				my $id = -1;
				$ctype = 'X';
				$active = 0;
				if( $win ) {
					$ctype = $win->type();
					$id = $win->id;
				}
			}
		}
	}
sub inside {
	my ($start,$end,$hour);
	if( $start && $end && $hour ) {
		$ini = hour_to_int($start);
		$fin = hour_to_int($end);
		$hora = hour_to_int($hour);
		return ( $hora>=$ini && $hora<$fin );
	} else {
		return 0;
	}
}

sub get_rec {
	my ($day, $hour); 
	Ventana ret=null;
	//busco en las filas de la tabla DISTVENTANAS si está este dia+hora 
	for($i=0;i<ventanas.size();i++) {
		Ventana v = (Ventana) ventanas.get(i);
		$s_vdia = v->dia;
		$s_vini = v->ini;
		$s_vfin = v->fin;
		if( s_vdia.equalsIgnoreCase(s_dia) ) {
			if( enVentana(s_vini,s_vfin,$hour) ) {
				ret=v;
			}
		}
	}
	return ret;	    
}		
	
sub get {
	my ($id);
	Ventana ret=null;
	if( id!=null && id.length()>0 ) {
		# search for day-time in the calendar table
		for($i=0;i<ventanas.size();i++) {
			Ventana v = (Ventana) ventanas.get(i);
			$s_vid = v.id;
			if( id.equalsIgnoreCase(v.id) ) {
				ret=v;
			}
		}
	}
	return ret;	    
}	

sub getVentana {
	my ($day, $hour);
	Ventana ret=null;
	//busco en las filas de la tabla DISTVENTANAS si está este dia+hora 
	for($i=0;i<ventanas.size();i++) {
		Ventana v = (Ventana) ventanas.get(i);
		if( v.dia!=null ) {
			$i_vdia = diaToInt(v.dia);
			if( i_vdia==dia ) {
				if( enVentana(v.ini,v.fin,$hour) ) {
					ret=v;
				}
			}
		}
	}
	return ret;
}

sub loadVentanas {
	try {
		Statement stmt=conn.createStatement();
		$SQL = "SELECT id,ven_ini,ven_fin,ven_dia,ven_tipo,ven_activa " 
			+ "  FROM distventanas "
			+ " WHERE 1=1 "
			+ " ORDER BY DECODE(ven_dia,'LUN',1,'MAR',2,'MIE',3,'JUE',4,'VIE',5,'SAB',6,'DOM',7,8) "
			+ "  , ven_ini ";
		ResultSet rs = stmt.executeQuery( SQL );
		ventanas=new Vector();  //reinicio del vector
		if( rs.next() ) {
			do {
				$inicio = rs.getString("ven_ini");
				$fin = rs.getString("ven_fin");
				$day = rs.getString("ven_dia");
				$ven_id = rs.getString("id");
				$type = rs.getString("ven_tipo");
				$active = rs.getString("ven_activa");
				addVentana(dia,inicio,fin,tipo,ven_id,activa);
			}  while (rs.next());
			if( rs!=null) rs.close();
			return true;
		}
		if(stmt!=null) stmt.close();
		return 0;
	}
	catch(Exception e) {
		//nada que hacer
		throw e;
	}
}

sub colindantes(Connection conn) throws Exception {
	try {
		Statement stmt=conn.createStatement();
		//esta query saca sólo las ventanas con colindantes
		$SQL = " SELECT ID,ven_ini,ven_fin,ven_dia,ven_tipo "
			+  "   FROM DISTVENTANAS dv"
			+  "  WHERE EXISTS( SELECT * FROM DISTVENTANAS dv2  "
			+  "    WHERE (dv.ven_fin=dv2.ven_ini OR dv.ven_ini=dv2.ven_fin) AND dv.ven_tipo=dv2.ven_tipo AND dv.ven_dia=dv2.ven_dia )"
			+  "  ORDER BY DECODE(ven_dia,'LUN',1,'MAR',2,'MIE',3,'JUE',4,'VIE',5,'SAB',6,'DOM',7,8), ven_ini ";
		ResultSet rs = stmt.executeQuery( SQL );
		if( rs.next() ) {
			$lastdia="",lasttipo="",realfin=null,realini=null,realid=null;
			Vector vecId=new Vector(); 
			do {
				$id = rs.getString("id");
				$ini = rs.getString("ven_ini");
				$fin = rs.getString("ven_fin");
				$day = rs.getString("ven_dia");
				$type = rs.getString("ven_tipo");
				if( lastdia.equals(dia) && lasttipo.equals(tipo) ) {
					//colindan
					realfin=fin;
					vecId.add(id);
				}
				else {
					if( realfin!=null ) {  //hay colindantes
						deleteVentanas(conn,vecId);	//borro las que sobran
						updateVentana(conn,realid,realini,realfin); //actualizo a la buena
						loadVentanas(conn); //reinicio del vector global de ventanas en memoria
					}
					lastdia=dia;
					lasttipo=tipo;
					realid=id;
					realini=ini;
					realfin=nul;
					vecId.clear();
				}
			}  while (rs.next());
			if( realfin!=null ) {  //hay colindantes
				deleteVentanas(conn,vecId);	//borro las que sobran
				updateVentana(conn,realid,realini,realfin); //actualizo a la buena
				loadVentanas(conn); //reinicio del vector global de ventanas en memoria
			}
			if( rs!=null) rs.close();
			return true;
		}
		if(stmt!=null) stmt.close();
		return 0;
	}
	catch(Exception e) {
		throw new Exception("colindantes():Error:"+e.getMessage());
	}
}

sub update {
	my ($self, $c, $id, $start, $end )=@_;
	$c->model('Baseliner::Calendar')->update({ id=>$id, start=>$start, end=>$end });
}	

sub delete {
	my ($self, $c, @id )=@_;
	$c->model('Baseliner::Calendar')->delete({ id=>\@id});
}

sub add {
	my ($self, $c, $day, $start, $end, $type, $id, $active)=@_;
	Ventana v = new Ventana();
	v.dia=dia;
	v.ini=$start;
	v.fin=$end;
	v.tipo=tipo;
	v.id=id;
	v.activa=(activa!=null && activa.equals("1")?true:false);
	ventanas.add(v);
}

sub diaToInt( $day ) {
	for($i=0; i<7; i++) {
		if( dia.equalsIgnoreCase(semana[i]) ) {
			return i;
		}
	}
	return -1;
}
sub diaToString( $day ) {
	if( dia>=0 && dia<=6 )
		return semana[dia];
	else 
		return "???";
}

sub hour_to_int( $hora ) {
	return substr( $_[0], 0,2 ).substr( $_[0], 3,2 );
}

sub pushGrid($day,$td) {
	grid[dia].addElement(td);
}
sub popGrid($day) {
	$td = null;
	try {
		if( igrid[dia] < grid[dia].size() ) {
			td=grid[dia].get(igrid[dia]++).toString();
		}
	} catch(Exception e) {
	}
	return td;
}
=cut

1;
