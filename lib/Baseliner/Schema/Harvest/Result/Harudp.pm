package Baseliner::Schema::Harvest::Result::Harudp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harudp");
__PACKAGE__->add_columns(
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "parentprocobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "outputtarget",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 8 },
  "onerroraction",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 8 },
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
  "description",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "programname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "inputparm",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "note",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "secureudpinput",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "udptype",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 8 },
);
__PACKAGE__->set_primary_key("processobjid");
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);
__PACKAGE__->belongs_to(
  "harlinkedprocess",
  "Baseliner::Schema::Harvest::Result::Harlinkedprocess",
  {
    parentprocobjid => "parentprocobjid",
    processobjid    => "processobjid",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O6Ko6BZ7ol+bNmzSWDFoow


# You can replace this text with custom content, and it will be preserved on regeneration
1;
