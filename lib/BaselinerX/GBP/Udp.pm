package BaselinerX::GBP::Udp;
use Baseliner::Plug;

register 'service.gbp.check_pkg' => {
	name => 'Chequea nomenclatura de paquetes',
	handler => sub {
		my ( $prj, $pkg )=@ARGV;
		( my $prj_id = $prj )=~ s{^....([0-9]{4}).*$}{$1}g;
		if( $pkg =~ /^H$prj_id(S|I|E)(.*)$/ ) {
			my ($orig, $cod ) = ($1,$2);
			if(  $orig eq 'S' ) {
				my ( $num, $seq ) = split /\@/,$cod;
				die "Código de Reg. de Objetivos inválido: '$cod'." if( length($cod) != 9);
				die "Secuencial de Reg. de Objetivos inválido: '$cod'." if( length($seq) != 2);
			}
			elsif(  $orig eq 'I' ) {
				my ( $num, $seq ) = split /\@/,$cod;
				die "Código de Remedy inválido: '$cod'." if( length($cod) != 9);
				die "Secuencial de Remedy inválido: '$cod'." if( length($seq) != 1);
			}
			elsif(  $orig eq 'E' ) {
				die "Código de Emergencia inválido: '$cod'." if( length($cod) != 10);
			}
			print "Nombre de paquete '$pkg' OK\n";
			exit 0;
		} else {
			print STDERR "*** Nombre de paquete inválido. Debe empezar por H$prj_id y seguido de S,I o E y el código.\n";
			exit 1;
		}
	}

};

register 'service.gbp.promote' => {
	name => 'Promueve paquetes pasando por varios estados',
	handler => sub {
		my ($self,$c,$inf)=@_;
		my ( $prj, $pkg )=@ARGV;
	}
};

register 'service.gbp.dependencias' => {
	name => 'Chequea dependencias entre paquetes al promover',
	handler => sub {
		my ($self,$c,$inf)=@_;
		my ( $prj, $pkg )=@ARGV;
	}
};

register 'service.gbp.act_correctivo' => {
	name => 'Actualiza el ciclo correctivo tras un pase a producción',
	handler => sub {
		my ($self,$c,$inf)=@_;
		my ( $prj, $pkg )=@ARGV;
	}
};

register 'service.gbp.act_desarrollo' => {
	name => 'Actualiza el ciclo desarrollo normal tras un pase a producción correctivo',
	handler => sub {
		my ($self,$c,$inf)=@_;
		my ( $prj, $pkg )=@ARGV;
	}
};

1;
