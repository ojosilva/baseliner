package Baseliner::Model::Baseliner;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Baseliner::Schema::Baseliner',
    connect_info => [
        'dbi:SQLite:baseliner2.db',
        
    ],
);

=head1 NAME

Baseliner::Model::Baseliner - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<Baseliner>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Baseliner::Schema::Baseliner>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
