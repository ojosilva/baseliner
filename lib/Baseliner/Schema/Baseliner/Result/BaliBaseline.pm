package Baseliner::Schema::Baseliner::Result::BaliBaseline;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_baseline");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "bl",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 100,
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
    size => 1024,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dnaPb9fkWsYFTXy36pmR1w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
