package Baseliner::Schema::Harvest::Result::Haritems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("haritems");
__PACKAGE__->add_columns(
  "itemobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "itemname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 256,
  },
  "itemnameupper",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 256,
  },
  "itemtype",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "parentobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "repositobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "creationtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "creatorid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
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
__PACKAGE__->set_primary_key("itemobjid");
__PACKAGE__->has_many(
  "harallchildrenpath_itemobjids",
  "Baseliner::Schema::Harvest::Result::Harallchildrenpath",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "harallchildrenpath_childitemids",
  "Baseliner::Schema::Harvest::Result::Harallchildrenpath",
  { "foreign.childitemid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "harbranches",
  "Baseliner::Schema::Harvest::Result::Harbranch",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "haritemaccesses",
  "Baseliner::Schema::Harvest::Result::Haritemaccess",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "haritemrelationships",
  "Baseliner::Schema::Harvest::Result::Haritemrelationship",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->belongs_to(
  "parentobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "parentobjid" },
);
__PACKAGE__->has_many(
  "haritems",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { "foreign.parentobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "harpathfullnames",
  "Baseliner::Schema::Harvest::Result::Harpathfullname",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "harversiondatas",
  "Baseliner::Schema::Harvest::Result::Harversiondata",
  { "foreign.itemobjid" => "self.itemobjid" },
);
__PACKAGE__->has_many(
  "harversions",
  "Baseliner::Schema::Harvest::Result::Harversions",
  { "foreign.itemobjid" => "self.itemobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iVtCz5qR59pUC/bak+goLA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
