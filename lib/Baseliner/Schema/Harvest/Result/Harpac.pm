package Baseliner::Schema::Harvest::Result::Harpac;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpac");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "pacbackoutplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacdatereported",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "pacdescription",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacid",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 40 },
  "pacimpactnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacimplementationdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "pacimplementationplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacinitiator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacinvestigator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacowner",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacplannedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacpriority",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "pacrejectedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacrejectnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacreviewedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pacreviewnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pacrisklevel",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 10 },
  "pacscope",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pactestedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "pactestplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pactestresults",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pactrainingplan",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "pactype",
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l4ZHMgbh+MH3fAeaRwg54Q


# You can replace this text with custom content, and it will be preserved on regeneration
1;
