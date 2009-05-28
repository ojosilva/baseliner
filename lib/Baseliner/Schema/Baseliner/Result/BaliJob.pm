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
    is_nullable => 0,
    size => 45,
  },
  "starttime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "maxstarttime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "endtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "status",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 45,
  },
  "ns",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 45,
  },
  "bl",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 45,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "bali_logs",
  "Baseliner::Schema::Baseliner::Result::BaliLog",
  { "foreign.job_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 13:57:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/t5zMe5mBlz2HaeT8YrgsQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->add_columns(
  "starttime",
  { data_type => "DATETIME", is_nullable => 0, size => 19, inflate_date=>0 },
  "maxstarttime",
  { data_type => "DATETIME", is_nullable => 0, size => 19, inflate_date=>0 },
  "endtime",
  { data_type => "DATETIME", is_nullable => 0, size => 19, inflate_date=>0 },
);
__PACKAGE__->add_columns(
  "runner",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
);
1;
