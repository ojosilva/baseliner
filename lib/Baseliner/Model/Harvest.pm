package Baseliner::Model::Harvest;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Baseliner::Schema::Harvest',
    connect_info => [
        'dbi:Oracle:TISO',
        'wtscm1',
        'wtscm1',
        
    ],
);

=head1 NAME

Baseliner::Model::Harvest - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Baseliner>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Baseliner::Schema::Harvest>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
