package Baseliner::Schema::Harvest::Result::Harusdhistory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusdhistory");
__PACKAGE__->add_columns(
  "harvestpackagename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "operation",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 20 },
  "result",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "webservice",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "faultcode",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "faultstring",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "usdpackagename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "usdpackageversion",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "logdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PwGcEKmkSWliOj8Y90qVbg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
