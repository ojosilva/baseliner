package Baseliner::Schema::Harvest::Result::Harpathfullname;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpathfullname");
__PACKAGE__->add_columns(
  "itemobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "pathfullname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1024,
  },
  "pathfullnameupper",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1024,
  },
);
__PACKAGE__->set_primary_key("itemobjid");
__PACKAGE__->belongs_to(
  "itemobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "itemobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jWeRXFwb5+RvGFBVqp/vVQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
