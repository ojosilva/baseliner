package Baseliner::Schema::Harvest::Result::Harrepository;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harrepository");
__PACKAGE__->add_columns(
  "repositobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "repositname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "rootpathid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "reponline",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 8 },
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
  "initialviewid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "hostnode",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "hostinstance",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 32,
  },
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "extensionoption",
  { data_type => "NUMBER", default_value => "1 ", is_nullable => 0, size => 126 },
  "compfile",
  { data_type => "CHAR", default_value => "'Y' ", is_nullable => 0, size => 1 },
  "notcompext",
  {
    data_type => "VARCHAR2",
    default_value => "'.zip.jpg.gif.asf.ram.mp3.wav.cab'\n\t",
    is_nullable => 1,
    size => 1000,
  },
  "mvsmapping",
  { data_type => "CHAR", default_value => "'M' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("repositobjid");
__PACKAGE__->has_many(
  "harfileextensions",
  "Baseliner::Schema::Harvest::Result::Harfileextension",
  { "foreign.repositobjid" => "self.repositobjid" },
);
__PACKAGE__->has_many(
  "harrepinviews",
  "Baseliner::Schema::Harvest::Result::Harrepinview",
  { "foreign.repositobjid" => "self.repositobjid" },
);
__PACKAGE__->has_many(
  "harrepositoryaccesses",
  "Baseliner::Schema::Harvest::Result::Harrepositoryaccess",
  { "foreign.repositobjid" => "self.repositobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Z6Dtqe7JkxNBJceswSZsRA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
