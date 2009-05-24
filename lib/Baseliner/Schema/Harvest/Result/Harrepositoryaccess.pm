package Baseliner::Schema::Harvest::Result::Harrepositoryaccess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harrepositoryaccess");
__PACKAGE__->add_columns(
  "repositobjid",
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
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "updateaccess",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "viewaccess",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("repositobjid", "usrgrpobjid");
__PACKAGE__->belongs_to(
  "repositobjid",
  "Baseliner::Schema::Harvest::Result::Harrepository",
  { repositobjid => "repositobjid" },
);
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:20CxYTukifdCAK52taZnrw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
