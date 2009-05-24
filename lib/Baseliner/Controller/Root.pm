package Baseliner::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Baseliner::Controller::Root - Root Controller for Baseliner

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

sub begin : Private {
    my ( $self, $c ) = @_;
    $c->res->headers->header( 'Cache-Control' => 'no-cache');
    $c->res->headers->header( Pragma => 'no-cache');
    $c->res->headers->header( Expires => 0 );
}

sub index:Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = '/site/index.html';
}

sub default:Path {
    my ( $self, $c ) = @_;
    $c->stash->{template} = $c->request->{path};
}

sub cc : Local {
	my ($self,$c)=@_;
	use YAML;
	$c->res->body( 
		"<pre>RES=" . 
		Dump($c->model('Baseliner::Bigtable')->search({ key=> { -like => 'config.%' } }) )
	);
}

## JSON stuff

use JSON::XS;
use constant js_true => JSON::XS::true;
use constant js_false => JSON::XS::false;
use MIME::Base64;
use YAML;

=head2 end

Renders a Mason view by default, passing it all parameters as <%args>.

=cut 

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
    $c->stash->{$_}=$c->request->parameters->{$_} 
    	foreach( keys %{ $c->req->parameters || ()});
}


=head1 AUTHOR

Rodrigo Gonzalez

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
