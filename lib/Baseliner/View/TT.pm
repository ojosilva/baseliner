package Baseliner::View::TT;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config->{INCLUDE_PATH} = [ Baseliner->path_to( 'root' ) ];
__PACKAGE__->config->{TEMPLATE_EXTENSION} = '.tt';
##__PACKAGE__->config->{PRE_PROCESS}        = 'global.tt';

=head1 NAME

Baseliner::View::TT - TT View for Baseliner

=head1 DESCRIPTION

TT View for Baseliner. 

=head1 AUTHOR

=head1 SEE ALSO

L<Baseliner>

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
