package Baseliner::Schema::Harvest::Result::Harview;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harview");
__PACKAGE__->add_columns(
  "viewobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "viewname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "viewtype",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 16 },
  "envobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "canviewexternally",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "baselineviewid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
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
  "snapshottime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("viewobjid");
__PACKAGE__->has_many(
  "harrepinviews",
  "Baseliner::Schema::Harvest::Result::Harrepinview",
  { "foreign.viewobjid" => "self.viewobjid" },
);
__PACKAGE__->has_many(
  "harstates",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { "foreign.viewobjid" => "self.viewobjid" },
);
__PACKAGE__->has_many(
  "harversioninviews",
  "Baseliner::Schema::Harvest::Result::Harversioninview",
  { "foreign.viewobjid" => "self.viewobjid" },
);
__PACKAGE__->belongs_to(
  "envobjid",
  "Baseliner::Schema::Harvest::Result::Harenvironment",
  { envobjid => "envobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NcH4ZK2QyFJaRc+8x3LR0w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
