package Baseliner::Schema::Harvest::Result::Harenvironmentaccess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harenvironmentaccess");
__PACKAGE__->add_columns(
  "envobjid",
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
  "executeaccess",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("envobjid", "usrgrpobjid");
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);
__PACKAGE__->belongs_to(
  "envobjid",
  "Baseliner::Schema::Harvest::Result::Harenvironment",
  { envobjid => "envobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RJbIOKIBg92HzTK/XHJNMQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
