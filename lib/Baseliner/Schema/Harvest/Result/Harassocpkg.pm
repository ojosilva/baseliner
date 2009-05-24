package Baseliner::Schema::Harvest::Result::Harassocpkg;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harassocpkg");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "assocpkgid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("formobjid", "assocpkgid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);
__PACKAGE__->belongs_to(
  "assocpkgid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "assocpkgid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VXe0JtEMId+/w5TzC9enCQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
