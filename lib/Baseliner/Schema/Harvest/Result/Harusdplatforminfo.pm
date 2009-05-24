package Baseliner::Schema::Harvest::Result::Harusdplatforminfo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusdplatforminfo");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "usdpackagename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "basedonpackage",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 172,
  },
  "loadpath",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "installfile",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 260,
  },
  "installparms",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "installtype",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "uninstallfile",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 260,
  },
  "uninstallparms",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "uninstalltype",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "beforelogoffflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "afterlogoffflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "offlineflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "promptflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "execprompttimeoutflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "resolvequerygroupsflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "payload",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "usdpackagecomment",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 500,
  },
  "targetoperatingsystem",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "usercancelflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "beforebootflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "afterbootflag",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "targetstate1",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "targetgroup1",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetcomputer1",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetstate2",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "targetgroup2",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetcomputer2",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetstate3",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "targetgroup3",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetcomputer3",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetstate4",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "targetgroup4",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetcomputer4",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetstate5",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "targetgroup5",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "targetcomputer5",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
);
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LDqOsI8ZVVj8XK8hyUyohg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
