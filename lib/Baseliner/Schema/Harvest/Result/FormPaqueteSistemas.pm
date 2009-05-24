package Baseliner::Schema::Harvest::Result::FormPaqueteSistemas;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_paquete_sistemas");
__PACKAGE__->add_columns(
  "sis_cam",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 3,
  },
  "environmentname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "versionobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "sis_status",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "sis_usr",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "sis_grp",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "sis_permisos",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "sis_path",
  {
    data_type => "VARCHAR2",
    default_value => "''",
    is_nullable => 1,
    size => 2048,
  },
  "usrobjid",
  { data_type => "NCHAR", default_value => undef, is_nullable => 1, size => 2 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XErXeTf/G/qAccpzZHZbuQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
