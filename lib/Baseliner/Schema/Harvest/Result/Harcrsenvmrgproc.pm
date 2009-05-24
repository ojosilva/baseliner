package Baseliner::Schema::Harvest::Result::Harcrsenvmrgproc;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harcrsenvmrgproc");
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
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "placement",
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
  "mergerule",
  { data_type => "CHAR", default_value => "'A' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("processobjid");
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ga+JRUpz2I/bgNKztqe9Cw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
