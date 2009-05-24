package Baseliner::Schema::Harvest::Result::Harformtypeuseraccessview;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformtypeuseraccessview");
__PACKAGE__->add_columns(
  "formtypeobjid",
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
  "secureaccess",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "updateaccess",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "viewaccess",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:as2fKuSmnSsA8qyeA3u1Ng


# You can replace this text with custom content, and it will be preserved on regeneration
1;
