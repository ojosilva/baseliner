package Baseliner::Schema::Harvest::Result::Harlinkedprocess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harlinkedprocess");
__PACKAGE__->add_columns(
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "parentprocobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processorder",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "processtype",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
  "processprelink",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("parentprocobjid", "processobjid");
__PACKAGE__->belongs_to(
  "stateobjid",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { stateobjid => "stateobjid" },
);
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "parentprocobjid", stateobjid => "stateobjid" },
);
__PACKAGE__->has_many(
  "harnotifies",
  "Baseliner::Schema::Harvest::Result::Harnotify",
  {
    "foreign.parentprocobjid" => "self.parentprocobjid",
    "foreign.processobjid"    => "self.processobjid",
  },
);
__PACKAGE__->has_many(
  "harnotifylists",
  "Baseliner::Schema::Harvest::Result::Harnotifylist",
  {
    "foreign.parentprocobjid" => "self.parentprocobjid",
    "foreign.processobjid"    => "self.processobjid",
  },
);
__PACKAGE__->has_many(
  "harudps",
  "Baseliner::Schema::Harvest::Result::Harudp",
  {
    "foreign.parentprocobjid" => "self.parentprocobjid",
    "foreign.processobjid"    => "self.processobjid",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vyu2QVe+ebMkrbhz5HFMOg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
