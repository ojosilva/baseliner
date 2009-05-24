package Baseliner::Schema::Harvest::Result::Harcheckoutproc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harcheckoutproc");
__PACKAGE__->add_columns(
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "pathoption",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "replacefile",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "itemnewer",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "updmode",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "concurupdmode",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "browsemode",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "reservemode",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "syncmode",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "creationtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "creatorid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "modifiedtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "modifierid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "clientdir",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "viewpath",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "sharedworkingdir",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "usecheckintimestamp",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
);
__PACKAGE__->set_primary_key("processobjid");
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:20DZEO27MCycnyInDGz5/g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
