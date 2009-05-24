package Baseliner::Schema::Harvest::Result::HarapprovehistviewTemp;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harapprovehistview_temp");
__PACKAGE__->add_columns(
  "envobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "packageobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "actiontime",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sPSZG9wM9yh2fbxFfNiMfg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
