package Baseliner::Schema::Baseliner::Result::BaliRelease;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_release");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "name",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 255,
  },
  "description",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "active",
  { data_type => "CHAR", default_value => 1, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-28 21:39:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e70tsHwMG04rO4n8ZgSAew


# You can replace this text with custom content, and it will be preserved on regeneration
1;
