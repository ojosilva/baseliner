package Baseliner::Schema::Harvest::Result::FormPaqueteVignette;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_paquete_vignette");
__PACKAGE__->add_columns(
  "vig_cam",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "vig_env",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "vig_red",
  {
    data_type => "VARCHAR2",
    default_value => "'LN'",
    is_nullable => 1,
    size => 2,
  },
  "vig_naturaleza",
  {
    data_type => "VARCHAR2",
    default_value => "'VIGNETTE'",
    is_nullable => 1,
    size => 50,
  },
  "vig_prepost",
  {
    data_type => "VARCHAR2",
    default_value => "'POST'",
    is_nullable => 1,
    size => 4,
  },
  "vig_maq",
  {
    data_type => "VARCHAR2",
    default_value => "NULL",
    is_nullable => 1,
    size => 50,
  },
  "vig_usu",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "vig_grupo",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "vig_accion",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 255,
  },
  "vig_pausa",
  { data_type => "CHAR", default_value => "'S'", is_nullable => 1, size => 1 },
  "vig_orden",
  { data_type => "NUMBER", default_value => 0, is_nullable => 1, size => 126 },
  "vig_block",
  { data_type => "CHAR", default_value => "'S'", is_nullable => 1, size => 1 },
  "vig_user",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 255,
  },
  "vig_activo",
  { data_type => "CHAR", default_value => "'S'", is_nullable => 1, size => 1 },
  "vig_errcode",
  {
    data_type => "NUMBER",
    default_value => 1
        ,
    is_nullable => 1,
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nhd0Y7QDVZPTqiQlYhG1eA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
