package Baseliner::Harvest::Result::Harform;

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
  "Baseliner::Harvest::Result::FormGbp",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->belongs_to(
  "formtypeobjid",
  "Baseliner::Harvest::Result::Harformtype",
  { formtypeobjid => "formtypeobjid" },
);
__PACKAGE__->has_many(
  "harformattachments",
  "Baseliner::Harvest::Result::Harformattachment",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->has_many(
  "harformhistories",
  "Baseliner::Harvest::Result::Harformhistory",
  { "foreign.formobjid" => "self.formobjid" },
);
__PACKAGE__->has_many(
  "harusdplatforminfoes",
  "Baseliner::Harvest::Result::Harusdplatforminfo",
  { "foreign.formobjid" => "self.formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-04-23 18:15:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aWLBYnJQMvLIhUK3PogCkQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
