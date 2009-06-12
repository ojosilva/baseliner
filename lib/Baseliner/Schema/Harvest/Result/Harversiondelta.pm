package Baseliner::Schema::Harvest::Result::Harversiondelta;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harversiondelta");
__PACKAGE__->add_columns(
  "childversiondataid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "parentversiondataid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "deltasize",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "versiondelta",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
);
__PACKAGE__->set_primary_key("childversiondataid", "parentversiondataid");
__PACKAGE__->belongs_to(
  "childversiondataid",
  "Baseliner::Schema::Harvest::Result::Harversiondata",
  { versiondataobjid => "childversiondataid" },
);
__PACKAGE__->belongs_to(
  "parentversiondataid",
  "Baseliner::Schema::Harvest::Result::Harversiondata",
  { versiondataobjid => "parentversiondataid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pB+Pl0iUhwTDt6+USgu/iQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
