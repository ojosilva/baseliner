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


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-28 20:49:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PeEalJ5UlJAfSYIa3TnTxA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
