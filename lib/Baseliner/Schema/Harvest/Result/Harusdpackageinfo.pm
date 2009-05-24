package Baseliner::Schema::Harvest::Result::Harusdpackageinfo;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusdpackageinfo");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "deploydate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "deployhour",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 2 },
  "deployminute",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 2 },
  "softwarevendor",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
  "usdpackagenameprefix",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "usdpackageversion",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 40,
  },
);
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NUFHGZ+jBzCQwyid2VZ+9w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
