package Baseliner::Schema::Harvest::Result::Harharvest;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harharvest");
__PACKAGE__->add_columns(
  "usrgrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "secureharvest",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "adminuser",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "viewuser",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "adminenvironment",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "viewenvironment",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "adminrepository",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "viewrepository",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "adminformtype",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "viewformtype",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("usrgrpobjid");
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RJgQsdJXPgfHnKEKn7Hvlg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
