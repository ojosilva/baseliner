package Baseliner::Schema::Baseliner::Result::BaliChain;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_chain");
__PACKAGE__->add_columns(
  "id",
  { data_type => "NUMBER", default_value => undef, is_nullable => 0, size => 38 },
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
    is_nullable => 0,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "bali_chained_services",
  "Baseliner::Schema::Baseliner::Result::BaliChainedService",
  { "foreign.chain_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QOZWgqKvH8iCfVMw7BXFgQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
