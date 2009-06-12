package Baseliner::Schema::Harvest::Result::Harpackagenamegen;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpackagenamegen");
__PACKAGE__->add_columns(
  "nameformat",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "namecounter",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("nameformat");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YDgcobXlsbxAa05Er9BIag


# You can replace this text with custom content, and it will be preserved on regeneration
1;
