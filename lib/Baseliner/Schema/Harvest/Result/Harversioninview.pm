package Baseliner::Schema::Harvest::Result::Harversioninview;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harversioninview");
__PACKAGE__->add_columns(
  "viewobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "versionobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("viewobjid", "versionobjid");
__PACKAGE__->belongs_to(
  "versionobjid",
  "Baseliner::Schema::Harvest::Result::Harversions",
  { versionobjid => "versionobjid" },
);
__PACKAGE__->belongs_to(
  "viewobjid",
  "Baseliner::Schema::Harvest::Result::Harview",
  { viewobjid => "viewobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cUXAqwd0pKLkK5k2SkJ9Yg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
