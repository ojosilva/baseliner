package Baseliner::Schema::Baseliner::Result::BaliLog;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_log");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "text",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1000,
  },
  "lev",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "job_id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "more",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "data",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
  "wiki_id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "job_id",
  "Baseliner::Schema::Baseliner::Result::BaliJob",
  { id => "job_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-28 20:49:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ex7npp3vZi8juWdxqeogOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
