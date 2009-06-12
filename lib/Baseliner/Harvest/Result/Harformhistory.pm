package Baseliner::Harvest::Result::Harformhistory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformhistory");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "execdtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "action",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
);
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-23 18:15:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PABpNoLHO6MSeb6ARqd/+g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
