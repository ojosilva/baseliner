package Baseliner::Schema::Harvest::Result::Harformtypeaccess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformtypeaccess");
__PACKAGE__->add_columns(
  "formtypeobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "usrgrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "secureaccess",
  { data_type => "CHAR", default_value => "'N'  ", is_nullable => 0, size => 1 },
  "updateaccess",
  { data_type => "CHAR", default_value => "'N'  ", is_nullable => 0, size => 1 },
  "viewaccess",
  { data_type => "CHAR", default_value => "'N'  ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("formtypeobjid", "usrgrpobjid");
__PACKAGE__->belongs_to(
  "formtypeobjid",
  "Baseliner::Schema::Harvest::Result::Harformtype",
  { formtypeobjid => "formtypeobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hf/Kqt/YMWN6Jz8NpGbOmQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
