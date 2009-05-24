package Baseliner::Schema::Harvest::Result::Harpasswordpolicy;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpasswordpolicy");
__PACKAGE__->add_columns(
  "maxage",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "minage",
  {
    data_type => "NUMBER",
    default_value => "0  ",
    is_nullable => 0,
    size => 126,
  },
  "minlen",
  { data_type => "NUMBER", default_value => "6 ", is_nullable => 0, size => 126 },
  "reuserule",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "maxfailures",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "allowusrchgexp",
  { data_type => "CHAR", default_value => "'Y' ", is_nullable => 0, size => 1 },
  "warningage",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "chrepetition",
  {
    data_type => "NUMBER",
    default_value => "-1 ",
    is_nullable => 0,
    size => 126,
  },
  "minnumeric",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "lowercase",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "uppercase",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "nonalphanum",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "allowusername",
  { data_type => "CHAR", default_value => "'Y' ", is_nullable => 0, size => 1 },
  "modifiedtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "modifierid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->belongs_to(
  "modifierid",
  "Baseliner::Schema::Harvest::Result::Harallusers",
  { usrobjid => "modifierid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fPeNn1v2BleDW0IlpHusog


# You can replace this text with custom content, and it will be preserved on regeneration
1;
