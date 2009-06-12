package Baseliner::Schema::Harvest::Result::Harform;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harform");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "formtypeobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "formname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
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
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->has_many(
  "form_gbps",
  "Baseliner::Schema::Harvest::Result::FormGbp",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->belongs_to(
  "formtypeobjid",
  "Baseliner::Schema::Harvest::Result::Harformtype",
  { formtypeobjid => "formtypeobjid" },
);
__PACKAGE__->has_many(
  "harformattachments",
  "Baseliner::Schema::Harvest::Result::Harformattachment",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->has_many(
  "harformhistories",
  "Baseliner::Schema::Harvest::Result::Harformhistory",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->has_many(
  "harusdplatforminfoes",
  "Baseliner::Schema::Harvest::Result::Harusdplatforminfo",
  { "foreign.formobjid" => "self.formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wbtKzu30Q9uEGwXejns7Sg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
