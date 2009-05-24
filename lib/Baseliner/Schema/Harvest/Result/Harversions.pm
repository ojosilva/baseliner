package Baseliner::Schema::Harvest::Result::Harversions;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harversions");
__PACKAGE__->add_columns(
  "versionobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "itemobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "parentversionid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "mergedversionid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "inbranch",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "mappedversion",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 16 },
  "versionstatus",
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
  "description",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "versiondataobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "clientmachine",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "clientpath",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "ancestorversionid",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
);
__PACKAGE__->set_primary_key("versionobjid");
__PACKAGE__->has_many(
  "haritemrelationships",
  "Baseliner::Schema::Harvest::Result::Haritemrelationship",
  { "foreign.versionobjid" => "self.versionobjid" },
);
__PACKAGE__->has_many(
  "harversioninviews",
  "Baseliner::Schema::Harvest::Result::Harversioninview",
  { "foreign.versionobjid" => "self.versionobjid" },
);
__PACKAGE__->belongs_to(
  "packageobjid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "packageobjid" },
);
__PACKAGE__->belongs_to(
  "itemobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "itemobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:j7MfQp/GJoVf1xamLKphqg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
