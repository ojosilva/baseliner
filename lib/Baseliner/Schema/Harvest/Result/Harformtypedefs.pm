package Baseliner::Schema::Harvest::Result::Harformtypedefs;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformtypedefs");
__PACKAGE__->add_columns(
  "attrid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "formtypeobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "columnname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "columntype",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 8,
  },
  "columnsize",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "defaultintvalue",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "defaultcharvalue",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "label",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("attrid");
__PACKAGE__->belongs_to(
  "formtypeobjid",
  "Baseliner::Schema::Harvest::Result::Harformtype",
  { formtypeobjid => "formtypeobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9IZBXtEHXabBWzst678f3Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
