package Baseliner::Schema::Harvest::Result::Harpackagestatus;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpackagestatus");
__PACKAGE__->add_columns(
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "clientname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1024,
  },
  "servername",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 1024,
  },
  "statusinfo",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
);
__PACKAGE__->set_primary_key("packageobjid");
__PACKAGE__->belongs_to(
  "packageobjid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "packageobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XmvyeMx9zVmqqE7x4eE7Kg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
