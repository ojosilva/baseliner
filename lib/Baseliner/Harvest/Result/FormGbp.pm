package Baseliner::Harvest::Result::FormGbp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_gbp");
__PACKAGE__->add_columns(
  "formobjid",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
  "gbp_desc",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "gbp_origen",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 21,
  },
  "gbp_rfc",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "gbp_inicio",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "gbp_fin",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "gbp_comentario",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-23 18:15:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ncz8Mp6P/tZRbNKmUbwOpg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->add_columns(
  "gbp_inicio",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19, inflate_date=>0 },
  "gbp_fin",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19, inflate_date=>0 },
  );
1;
