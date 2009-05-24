package Baseliner::Schema::Harvest::Result::Harlistversproc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harlistversproc");
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
  "changedescription",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "actualchanges",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
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
  "toviewpath",
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
);
__PACKAGE__->set_primary_key("processobjid");
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z5g0oNeoNxQHMVDCPR+uRA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
