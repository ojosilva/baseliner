package Baseliner::Schema::Harvest::Result::Harallusers;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harallusers");
__PACKAGE__->add_columns(
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "username",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
  "logindate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "lastlogin",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "loggedin",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "realname",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 128 },
  "phonenumber",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "extension",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
  "faxnumber",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "encryptpsswd",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
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
  "email",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("usrobjid");
__PACKAGE__->has_many(
  "harpackages",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { "foreign.assigneeid" => "self.usrobjid" },
);
__PACKAGE__->has_many(
  "harpasswordpolicies",
  "Baseliner::Schema::Harvest::Result::Harpasswordpolicy",
  { "foreign.modifierid" => "self.usrobjid" },
);
__PACKAGE__->has_many(
  "haruserdatas",
  "Baseliner::Schema::Harvest::Result::Haruserdata",
  { "foreign.usrobjid" => "self.usrobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lOE4Zp6jogYIe+vGu8hZCQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
