package Baseliner::Schema::Harvest::Result::Harusergroup;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusergroup");
__PACKAGE__->add_columns(
  "usrgrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "usergroupname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
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
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("usrgrpobjid");
__PACKAGE__->has_many(
  "harapprovelists",
  "Baseliner::Schema::Harvest::Result::Harapprovelist",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harenvironmentaccesses",
  "Baseliner::Schema::Harvest::Result::Harenvironmentaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harformtypeaccesses",
  "Baseliner::Schema::Harvest::Result::Harformtypeaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harharvests",
  "Baseliner::Schema::Harvest::Result::Harharvest",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "haritemaccesses",
  "Baseliner::Schema::Harvest::Result::Haritemaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harnotifylists",
  "Baseliner::Schema::Harvest::Result::Harnotifylist",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harrepositoryaccesses",
  "Baseliner::Schema::Harvest::Result::Harrepositoryaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harstateaccesses",
  "Baseliner::Schema::Harvest::Result::Harstateaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harstateprocessaccesses",
  "Baseliner::Schema::Harvest::Result::Harstateprocessaccess",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);
__PACKAGE__->has_many(
  "harusersingroups",
  "Baseliner::Schema::Harvest::Result::Harusersingroup",
  { "foreign.usrgrpobjid" => "self.usrgrpobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3DjDNUgpUwTNDXJ8dhDNpA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
