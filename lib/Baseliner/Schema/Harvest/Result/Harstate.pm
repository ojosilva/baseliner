package Baseliner::Schema::Harvest::Result::Harstate;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harstate");
__PACKAGE__->add_columns(
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "statename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "envobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "stateorder",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "viewobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "snapshot",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
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
  "locationx",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "locationy",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "pmstatusindex",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
);
__PACKAGE__->set_primary_key("stateobjid");
__PACKAGE__->has_many(
  "harlinkedprocesses",
  "Baseliner::Schema::Harvest::Result::Harlinkedprocess",
  { "foreign.stateobjid" => "self.stateobjid" },
);
__PACKAGE__->belongs_to(
  "envobjid",
  "Baseliner::Schema::Harvest::Result::Harenvironment",
  { envobjid => "envobjid" },
);
__PACKAGE__->belongs_to(
  "viewobjid",
  "Baseliner::Schema::Harvest::Result::Harview",
  { viewobjid => "viewobjid" },
);
__PACKAGE__->belongs_to(
  "pmstatusindex",
  "Baseliner::Schema::Harvest::Result::Harpmstatus",
  { pmstatusindex => "pmstatusindex" },
);
__PACKAGE__->has_many(
  "harstateaccesses",
  "Baseliner::Schema::Harvest::Result::Harstateaccess",
  { "foreign.stateobjid" => "self.stateobjid" },
);
__PACKAGE__->has_many(
  "harstateprocesses",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { "foreign.stateobjid" => "self.stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rOZ52E0maxcwk62A3s7bjw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
