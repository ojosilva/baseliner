package Baseliner::Schema::Harvest::Result::Hartableinfo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hartableinfo");
__PACKAGE__->add_columns(
  "versionindicator",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "casesenslogin",
  { data_type => "CHAR", default_value => "'Y' ", is_nullable => 0, size => 1 },
  "databaseid",
  {
    data_type => "NUMBER",
    default_value => "0  ",
    is_nullable => 0,
    size => 126,
  },
  "authenticateuser",
  { data_type => "CHAR", default_value => "'Y' ", is_nullable => 0, size => 1 },
  "sysvarpw",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RdW63ixXfbIw/u8EkK6+9w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
