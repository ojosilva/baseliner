package Baseliner::Schema::Harvest::Result::Harpackage;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpackage");
__PACKAGE__->add_columns(
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "packagename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "envobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "stateobjid",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "viewobjid",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "approved",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "status",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
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
  "packagedes",
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
  "priority",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "assigneeid",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "stateentrytime",
  {
    data_type => "DATE",
    default_value => "SYSDATE ",
    is_nullable => 0,
    size => 19,
  },
  "notifywebservice",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("packageobjid");
__PACKAGE__->has_many(
  "harassocpkgs",
  "Baseliner::Schema::Harvest::Result::Harassocpkg",
  { "foreign.assocpkgid" => "self.packageobjid" },
);
__PACKAGE__->belongs_to(
  "assigneeid",
  "Baseliner::Schema::Harvest::Result::Harallusers",
  { usrobjid => "assigneeid" },
);
__PACKAGE__->belongs_to(
  "envobjid",
  "Baseliner::Schema::Harvest::Result::Harenvironment",
  { envobjid => "envobjid" },
);
__PACKAGE__->has_many(
  "harpackagestatuses",
  "Baseliner::Schema::Harvest::Result::Harpackagestatus",
  { "foreign.packageobjid" => "self.packageobjid" },
);
__PACKAGE__->has_many(
  "harpkghistories",
  "Baseliner::Schema::Harvest::Result::Harpkghistory",
  { "foreign.packageobjid" => "self.packageobjid" },
);
__PACKAGE__->has_many(
  "harpkgsincmews",
  "Baseliner::Schema::Harvest::Result::Harpkgsincmew",
  { "foreign.packageobjid" => "self.packageobjid" },
);
__PACKAGE__->has_many(
  "harpkgsinpkggrps",
  "Baseliner::Schema::Harvest::Result::Harpkgsinpkggrp",
  { "foreign.packageobjid" => "self.packageobjid" },
);
__PACKAGE__->has_many(
  "harusddeployinfoes",
  "Baseliner::Schema::Harvest::Result::Harusddeployinfo",
  { "foreign.packageobjid" => "self.packageobjid" },
);
__PACKAGE__->has_many(
  "harversions",
  "Baseliner::Schema::Harvest::Result::Harversions",
  { "foreign.packageobjid" => "self.packageobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4JUn3x+dATF35WyHshYxRw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
