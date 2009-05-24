package Baseliner::Schema::Baseliner::Result::BaliConfigset;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_configset");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "namespace_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
  "baseline_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
  "wiki_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
  "created_on",
  { data_type => "DATETIME", is_nullable => 0, size => 19 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qh+5niLJIA7wvUEiv5l28w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
