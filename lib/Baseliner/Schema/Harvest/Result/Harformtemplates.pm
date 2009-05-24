package Baseliner::Schema::Harvest::Result::Harformtemplates;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformtemplates");
__PACKAGE__->add_columns(
  "formtypeobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "fileextension",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "filesize",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "filedata",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
  "creatorid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "creationtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "modifierid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "modifiedtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("formtypeobjid", "fileextension");
__PACKAGE__->belongs_to(
  "formtypeobjid",
  "Baseliner::Schema::Harvest::Result::Harformtype",
  { formtypeobjid => "formtypeobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SZS3QYDo2vTAvnRp4cw24w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
