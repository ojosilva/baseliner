package Baseliner::Schema::Harvest::Result::Hardefect;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hardefect");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "dtapplication",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "dtcategory",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "dtcomponent",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "dtconfirmedby",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "dtconfirmedos",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtconfirmedversion",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtdateclosed",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "dtdateconfirmed",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "dtdatereported",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "dtdefectkey",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 19 },
  "dtdescription",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dtdeveloper",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtdocimpact",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "dtdocument",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 130,
  },
  "dtfixby",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "dtimpact",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 9 },
  "dtinvestigator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtinvestnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dtkeyword",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "dtlikelihood",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 9 },
  "dtmilestone",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "dtorigin",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
  "dtothercategory",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "dtpriority",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "dtrecommend",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 77,
  },
  "dtreleasenum",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtreportedby",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "dtreportedos",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtresolution",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dtrevisionnum",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dtseverity",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 21 },
  "dttestcases",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dttester",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "dttestresults",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "dtunittest",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dPoNmVAvbBPyXPqbPX7aHw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
