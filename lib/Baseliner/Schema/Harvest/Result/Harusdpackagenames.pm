package Baseliner::Schema::Harvest::Result::Harusdpackagenames;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusdpackagenames");
__PACKAGE__->add_columns(
  "nameversion",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 172,
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
  "usdpackageuuid",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AwMX/NJh/54d4IjMci7KgQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
