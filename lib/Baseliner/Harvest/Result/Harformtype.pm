package Baseliner::Harvest::Result::Harformtype;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harformtype");
__PACKAGE__->add_columns(
  "formtypeobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "formtablename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "formtypename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "notifywebservice",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("formtypeobjid");
__PACKAGE__->has_many(
  "harforms",
  "Baseliner::Harvest::Result::Harform",
  { "foreign.formtypeobjid" => "self.formtypeobjid" },
);
__PACKAGE__->has_many(
  "harformtemplates",
  "Baseliner::Harvest::Result::Harformtemplates",
  { "foreign.formtypeobjid" => "self.formtypeobjid" },
);
__PACKAGE__->has_many(
  "harformtypeaccesses",
  "Baseliner::Harvest::Result::Harformtypeaccess",
  { "foreign.formtypeobjid" => "self.formtypeobjid" },
);
__PACKAGE__->has_many(
  "harformtypedefs",
  "Baseliner::Harvest::Result::Harformtypedefs",
  { "foreign.formtypeobjid" => "self.formtypeobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-23 18:15:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VYJyWQAR2ZFrjPoYEx/9VA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
