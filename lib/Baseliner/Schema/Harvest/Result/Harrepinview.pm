package Baseliner::Schema::Harvest::Result::Harrepinview;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harrepinview");
__PACKAGE__->add_columns(
  "viewobjid",
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
  "readonly",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "repfromviewid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("viewobjid", "repositobjid");
__PACKAGE__->belongs_to(
  "viewobjid",
  "Baseliner::Schema::Harvest::Result::Harview",
  { viewobjid => "viewobjid" },
);
__PACKAGE__->belongs_to(
  "repositobjid",
  "Baseliner::Schema::Harvest::Result::Harrepository",
  { repositobjid => "repositobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IwPVWXIz0GrbI9D0HBh01w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
