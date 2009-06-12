package Baseliner::Schema::Harvest::Result::Harpkgsinpkggrp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpkgsinpkggrp");
__PACKAGE__->add_columns(
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "pkggrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("packageobjid", "pkggrpobjid");
__PACKAGE__->belongs_to(
  "pkggrpobjid",
  "Baseliner::Schema::Harvest::Result::Harpackagegroup",
  { pkggrpobjid => "pkggrpobjid" },
);
__PACKAGE__->belongs_to(
  "packageobjid",
  "Baseliner::Schema::Harvest::Result::Harpackage",
  { packageobjid => "packageobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d6MwuD70onXgizb2tyDVmA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
