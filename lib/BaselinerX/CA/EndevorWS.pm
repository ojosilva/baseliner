package BaselinerX::EndevorWS;
use Baseliner::Plug;
extends 'Catalyst::Component';

use SOAP::Lite;
#SOAP::Lite->import(+trace => qw(debug));

register 'config.endevor.ws' => {
	metadata=> [
		{ id=>'proxy_endevor', label=>'Endevor WebServices URL', type=>'text', default=>'http://swdla027:8080/EndevorService/services/EndevorService' },
		{ id=>'proxy_cmew', label=>'Endevor WebServices URL', type=>'text', default=>'http://swdla027:8080/CmewService/services/EndevorService' },
		{ id=>'service_name', label=>'Endevor Service Provider Name', type=>'text', default=>'endevor' },
		{ id=>'service_url', label=>'Endevor WebServices URL', type=>'text', default=>'http://service.endevor.ecm.ca.com' },
	]
};

sub _call_endevor {
	my ($self,$b)=@_;
	my $soap = SOAP::Lite->proxy( $b->{'config.endevor.ws.proxy_endevor'} );
	$soap->serializer()->register_ns( "http://service.endevor.ecm.ca.com" , 'ser');
	my $data = SOAP::Data->value(
		SOAP::Data->name("loginProperties" =>
			\SOAP::Data->value(
				SOAP::Data->name("endevorDataSourceName" => $b->{'config.endevor.ws.service_name'}),
				SOAP::Data->name("endevorPassword" => $b->stash->{password} ),
				SOAP::Data->name("endevorUserName" => $b->stash->{user} ),
			)
		),
		SOAP::Data->name("packageName" => $b->stash->{package_name} )
	);
	my $som = $soap->executePackage( $data->prefix('ser') );
}

1;
