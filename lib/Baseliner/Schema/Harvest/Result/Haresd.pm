package Baseliner::Schema::Harvest::Result::Haresd;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("haresd");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "esdbackoutplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdcertificationresults",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esddeploymentplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esddescription",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdhwdependencynotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdid",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 40 },
  "esdimpactnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdimplementationdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "esdinitiator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdinvestigator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdplannedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdpriority",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "esdrejectedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdrejectnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdrequestdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "esdrequiredspace",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 40 },
  "esdreviewedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdreviewnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdrisklevel",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "esdscope",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdscriptnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdswdependencynotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdtestedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "esdtestplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdtrainingplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "esdtype",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 52,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MfYnnOZ2Yl7wLA+UvpQwdw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
