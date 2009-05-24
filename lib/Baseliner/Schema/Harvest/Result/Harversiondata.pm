package Baseliner::Schema::Harvest::Result::Harversiondata;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harversiondata");
__PACKAGE__->add_columns(
  "versiondataobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "refcounter",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "datasize",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "compressed",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "compdatasize",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "fileaccess",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 9 },
  "modifytime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "createtime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "dcb",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 256,
  },
  "textfile",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "itemobjid",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "versiondata",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
);
__PACKAGE__->set_primary_key("versiondataobjid");
__PACKAGE__->belongs_to(
  "itemobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "itemobjid" },
);
__PACKAGE__->has_many(
  "harversiondelta_childversiondataids",
  "Baseliner::Schema::Harvest::Result::Harversiondelta",
  { "foreign.childversiondataid" => "self.versiondataobjid" },
);
__PACKAGE__->has_many(
  "harversiondelta_parentversiondataids",
  "Baseliner::Schema::Harvest::Result::Harversiondelta",
  { "foreign.parentversiondataid" => "self.versiondataobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MLNim6tBQKGE99EZcvYfxw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
