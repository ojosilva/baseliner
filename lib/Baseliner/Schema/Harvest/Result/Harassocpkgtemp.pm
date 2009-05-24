package Baseliner::Schema::Harvest::Result::Harassocpkgtemp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harassocpkgtemp");
__PACKAGE__->add_columns(
  "assocpkgid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5ZypTy6qGIQ0CH8KpLjw6A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
