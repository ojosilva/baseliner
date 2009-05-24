package Baseliner::Schema::Harvest::Result::FormPaquetePrepost;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_paquete_prepost");
__PACKAGE__->add_columns(
  "pp_cam",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "pp_env",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "pp_naturaleza",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "pp_prepost",
  {
    data_type => "VARCHAR2",
    default_value => "'PRE'",
    is_nullable => 1,
    size => 4,
  },
  "pp_exec",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2048,
  },
  "pp_maq",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "pp_usu",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "pp_os",
  {
    data_type => "VARCHAR2",
    default_value => "'UNIX'",
    is_nullable => 1,
    size => 4,
  },
  "pp_block",
  { data_type => "CHAR", default_value => "'N'", is_nullable => 1, size => 1 },
  "pp_orden",
  { data_type => "NUMBER", default_value => 0, is_nullable => 1, size => 126 },
  "pp_user",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 255,
  },
  "pp_activo",
  { data_type => "CHAR", default_value => "'S'", is_nullable => 1, size => 1 },
  "pp_errcode",
  {
    data_type => "NUMBER",
    default_value => 1
        ,
    is_nullable => 1,
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HYwcknKKJzz9QdoLW0hnaQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
