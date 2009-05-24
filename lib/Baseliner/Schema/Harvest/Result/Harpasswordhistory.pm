package Baseliner::Schema::Harvest::Result::Harpasswordhistory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpasswordhistory");
__PACKAGE__->add_columns(
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "prevpsswds",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 0,
    size => 2147483647,
  },
);
__PACKAGE__->set_primary_key("usrobjid");
__PACKAGE__->belongs_to(
  "usrobjid",
  "Baseliner::Schema::Harvest::Result::Haruser",
  { usrobjid => "usrobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YWLydIQQ7juuHwRSiH9/Fw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
