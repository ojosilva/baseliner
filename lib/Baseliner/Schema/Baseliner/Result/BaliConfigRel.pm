package Baseliner::Schema::Baseliner::Result::BaliConfigRel;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_config_rel");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "namespace_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
  "plugin_id",
  { data_type => "INT", is_nullable => 0, size => 10 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aUBh2MHUR2SP/BUufZbXUA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
