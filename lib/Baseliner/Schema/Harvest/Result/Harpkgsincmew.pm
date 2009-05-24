package Baseliner::Schema::Harvest::Result::Harpkgsincmew;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpkgsincmew");
__PACKAGE__->add_columns(
  "epackageobjid",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
  "epackagename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 200,
  },
  "packageobjid",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
  "cmewstatus",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("epackageobjid", "packageobjid");
__PACKAGE__->belongs_to(
  "packageobjid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "packageobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RxLzDEsX/ON/x0WTbk1rsA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
