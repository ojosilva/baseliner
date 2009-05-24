package Baseliner::Schema::Baseliner::Result::BaliUser;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_user");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "username",
  { data_type => "VARCHAR", is_nullable => 0, size => 45 },
  "password",
  { data_type => "VARCHAR", is_nullable => 0, size => 45 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/Hsrh7THf7DISXgyXg/2Ow


# You can replace this text with custom content, and it will be preserved on regeneration
1;
