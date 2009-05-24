package Baseliner::Schema::Harvest::Result::Harobjectsequenceid;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harobjectsequenceid");
__PACKAGE__->add_columns(
  "hartablename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "harsequenceid",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("hartablename");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0khRvnW4k0HSh6pf8igbEw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
