package Baseliner::Schema::Baseliner::Result::BaliNamespace;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_namespace");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "namespace",
  { data_type => "VARCHAR", is_nullable => 0, size => 250 },
  "is_root",
  { data_type => "TINYINT", is_nullable => 0, size => 1 },
  "template",
  { data_type => "VARCHAR", is_nullable => 0, size => 45 },
  "wiki_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
  "active",
  { data_type => "VARCHAR", is_nullable => 0, size => 1 },
  "node",
  { data_type => "VARCHAR", is_nullable => 0, size => 45 },
  "is_folder",
  { data_type => "TINYINT", is_nullable => 0, size => 1 },
  "service",
  { data_type => "VARCHAR", is_nullable => 0, size => 45 },
  "parent_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4YtQR5elJYSj7tKz6xMZhw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
