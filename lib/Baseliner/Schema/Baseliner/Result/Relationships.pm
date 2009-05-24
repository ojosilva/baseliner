package Baseliner::Schema::Baseliner::Result::Relationships;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("relationships");
__PACKAGE__->add_columns(
  "from_id",
  { data_type => "NUMERIC", is_nullable => 0, size => undef },
  "to_id",
  { data_type => "NUMERIC", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("from_id", "to_id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TF3DNLyprEkiR+M86/IjpA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
