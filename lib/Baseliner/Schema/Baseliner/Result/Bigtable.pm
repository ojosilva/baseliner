package Baseliner::Schema::Baseliner::Result::Bigtable;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bigtable");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "ns",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "bl",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "key",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "value",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "ts",
  { data_type => "DATETIME", is_nullable => 0, size => undef },
  "ref",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "reftable",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "data",
  { data_type => "BLOB", is_nullable => 0, size => undef },
  "parent_id",
  { data_type => "integer", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NMQDUCGvvSSoIPCVcVbIJg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
