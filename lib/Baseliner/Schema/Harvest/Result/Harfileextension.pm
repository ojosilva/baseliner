package Baseliner::Schema::Harvest::Result::Harfileextension;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harfileextension");
__PACKAGE__->add_columns(
  "repositobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "fileextension",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("repositobjid", "fileextension");
__PACKAGE__->belongs_to(
  "repositobjid",
  "Baseliner::Schema::Harvest::Result::Harrepository",
  { repositobjid => "repositobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:58hi5GZmMzWlfQ0/OICOqQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
