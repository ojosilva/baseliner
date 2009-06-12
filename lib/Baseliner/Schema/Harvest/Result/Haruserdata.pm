package Baseliner::Schema::Harvest::Result::Haruserdata;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("haruserdata");
__PACKAGE__->add_columns(
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "encryptpsswd",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
  "maxage",
  {
    data_type => "NUMBER",
    default_value => "-2 ",
    is_nullable => 0,
    size => 126,
  },
  "failures",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "psswdtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "accountexternal",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("usrobjid");
__PACKAGE__->belongs_to(
  "usrobjid",
  "Baseliner::Schema::Harvest::Result::Haruser",
  { usrobjid => "usrobjid" },
);
__PACKAGE__->belongs_to(
  "usrobjid",
  "Baseliner::Schema::Harvest::Result::Harallusers",
  { usrobjid => "usrobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Vh5vDNRno+WxcG+ZjDZVHg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
