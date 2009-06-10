package Baseliner::Schema::Baseliner::Result::BaliJobItems;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_job_items");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "data",
  {
    data_type => "CLOB",
    default_value => undef,
    is_nullable => 1,
    size => 2147483647,
  },
  "item",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "provider",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1024,
  },
  "id_job",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "service",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "id_job",
  "Baseliner::Schema::Baseliner::Result::BaliJob",
  { id => "id_job" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qe6ObGAWeOc5O1RSM4lOTg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
