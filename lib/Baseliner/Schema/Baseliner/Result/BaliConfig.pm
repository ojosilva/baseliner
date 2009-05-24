package Baseliner::Schema::Baseliner::Result::BaliConfig;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_config");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "ns",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1000,
  },
  "bl",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "key",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 100,
  },
  "value",
  {
    data_type => "VARCHAR2",
    default_value => "SYSDATE",
    is_nullable => 1,
    size => 100,
  },
  "ts",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "ref",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "reftable",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 100,
  },
  "data",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
  "parent_id",
  { data_type => "NUMBER", default_value => 0, is_nullable => 0, size => 126 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 13:57:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3Ca9twYRiFYKUS0Tpp09Hw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
