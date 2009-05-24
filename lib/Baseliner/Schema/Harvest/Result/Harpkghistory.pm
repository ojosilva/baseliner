package Baseliner::Schema::Harvest::Result::Harpkghistory;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpkghistory");
__PACKAGE__->add_columns(
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "statename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "environmentname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "execdtime",
  { data_type => "DATE", default_value => undef, is_nullable => 0, size => 19 },
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "action",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
);
__PACKAGE__->belongs_to(
  "packageobjid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "packageobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PslWo2nSmQTO/Nk4qacylA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
