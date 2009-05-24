package Baseliner::Schema::Harvest::Result::Harusercontact;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusercontact");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "contactextension",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "zip",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "contactphone",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "state",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "city",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "contactfax",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "contactname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "contacttitle",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "country",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "position",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "mailstop",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 130,
  },
  "organization",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 130,
  },
  "address",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 257,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RQuigdG8cUCyDoRJO41xVQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
