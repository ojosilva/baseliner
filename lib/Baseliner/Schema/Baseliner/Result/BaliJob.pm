package Baseliner::Schema::Baseliner::Result::BaliJob;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_job");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "name",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 45,
  },
  "starttime",
  {
    data_type => "DATE",
    default_value => "SYSDATE               ",
    is_nullable => 0,
    size => 19,
  },
  "maxstarttime",
  {
    data_type => "DATE",
    default_value => "SYSDATE+1             ",
    is_nullable => 0,
    size => 19,
  },
  "endtime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "status",
  {
    data_type => "VARCHAR2",
    default_value => "'READY'             ",
    is_nullable => 0,
    size => 45,
  },
  "ns",
  {
    data_type => "VARCHAR2",
    default_value => "'/'                   ",
    is_nullable => 0,
    size => 45,
  },
  "bl",
  {
    data_type => "VARCHAR2",
    default_value => "'*'                   ",
    is_nullable => 0,
    size => 45,
  },
  "runner",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "pid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "comments",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "type",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "userid",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "ts",
  {
    data_type => "DATE",
    default_value => "sysdate",
    is_nullable => 1,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "bali_job_items",
  "Baseliner::Schema::Baseliner::Result::BaliJobItems",
  { "foreign.id_job" => "self.id" },
);
__PACKAGE__->has_many(
  "bali_logs",
  "Baseliner::Schema::Baseliner::Result::BaliLog",
  { "foreign.job_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wfbn7jYV92mVC3XVSmIdLw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
