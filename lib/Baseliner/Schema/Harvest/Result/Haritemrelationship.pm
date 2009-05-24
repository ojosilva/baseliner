package Baseliner::Schema::Harvest::Result::Haritemrelationship;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("haritemrelationship");
__PACKAGE__->add_columns(
  "itemobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "refitemid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "relationship",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 10 },
  "versionobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("itemobjid", "refitemid", "versionobjid");
__PACKAGE__->belongs_to(
  "itemobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "itemobjid" },
);
__PACKAGE__->belongs_to(
  "versionobjid",
  "Baseliner::Schema::Harvest::Result::Harversions",
  { versionobjid => "versionobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N6nuYA1QPuLEjG1gcuYMIg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
