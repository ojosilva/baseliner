package Baseliner::Schema::Harvest::Result::FormPaquete;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_paquete");
__PACKAGE__->add_columns(
  "formobjid",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
  "paq_tipo",
  {
    data_type => "VARCHAR2",
    default_value => "'Incidencia'",
    is_nullable => 1,
    size => 128,
  },
  "paq_observaciones",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 4000,
  },
  "pas_codigo",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 17,
  },
  "paq_ciclo",
  {
    data_type => "VARCHAR2",
    default_value => "'Normal (Con Preproduccion)'",
    is_nullable => 1,
    size => 128,
  },
  "paq_desc",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "paq_pro",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 30,
  },
  "paq_inc",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 50,
  },
  "paq_origen",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "paq_motivo",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "paq_error",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "paq_usuario",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "paq_mant",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "paq_cambio",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "paq_comentario",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "paq_pet",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 30,
  },
  "paq_accion_reinicio",
  { data_type => "CHAR", default_value => "'Y'\n", is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("formobjid");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JcffJDZPCeDF00vRhHs8Nw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
