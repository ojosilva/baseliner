package Baseliner::Schema::Harvest::Result::Hartimesheet;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("hartimesheet");
__PACKAGE__->add_columns(
  "formobjid",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
  "userobjid",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "packageobjid",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "modifiedtime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "usertime",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WymoBwVs8r7sTVO4dLk1gQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
