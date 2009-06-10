package Baseliner::Schema::Baseliner::Result::BaliRelationship;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_relationship");
__PACKAGE__->add_columns(
  "from_id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "to_id",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "type",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 45,
  },
);
__PACKAGE__->set_primary_key("to_id", "from_id");
__PACKAGE__->belongs_to(
  "from_id",
  "Baseliner::Schema::Baseliner::Result::BaliConfig",
  { id => "from_id" },
);
__PACKAGE__->belongs_to(
  "to_id",
  "Baseliner::Schema::Baseliner::Result::BaliConfig",
  { id => "to_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fjosQPFTVfk6j/G0VCpvmA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
