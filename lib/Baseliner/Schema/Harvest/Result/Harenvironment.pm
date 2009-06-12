package Baseliner::Schema::Harvest::Result::Harenvironment;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harenvironment");
__PACKAGE__->add_columns(
  "envobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "environmentname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "envisactive",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "baselineviewid",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
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
  "isarchive",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "archiveby",
  { data_type => "NUMBER", default_value => "1 ", is_nullable => 0, size => 126 },
  "archivemachine",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 256 },
  "archivefile",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 256 },
  "archivetime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
);
__PACKAGE__->set_primary_key("envobjid");
__PACKAGE__->has_many(
  "harapprovehists",
  "Baseliner::Schema::Harvest::Result::Harapprovehist",
  { "foreign.envobjid" => "self.envobjid" },
);
__PACKAGE__->has_many(
  "harenvironmentaccesses",
  "Baseliner::Schema::Harvest::Result::Harenvironmentaccess",
  { "foreign.envobjid" => "self.envobjid" },
);
__PACKAGE__->has_many(
  "harpackages",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { "foreign.envobjid" => "self.envobjid" },
);
__PACKAGE__->has_many(
  "harpackagegroups",
  "Baseliner::Schema::Harvest::Result::Harpackagegroup",
  { "foreign.envobjid" => "self.envobjid" },
);
__PACKAGE__->has_many(
  "harstates",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { "foreign.envobjid" => "self.envobjid" },
);
__PACKAGE__->has_many(
  "harviews",
  "Baseliner::Schema::Harvest::Result::Harview",
  { "foreign.envobjid" => "self.envobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7WGP5xvcJPzJ7ly4yrkghQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
