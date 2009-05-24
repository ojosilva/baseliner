package Baseliner::Schema::Harvest::Result::Harmr;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harmr");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "mrdatereported",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "mrreportedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 44 },
  "mrcategory",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 12 },
  "mrothercategory",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 30 },
  "mrapplication",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "mrreleasenum",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrhardware",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "mroperatingsys",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrdocument",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 130,
  },
  "mrrevisionnum",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrdescript",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "mrkeyword",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "mrseverity",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrinvestnotes",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "mrinvestigator",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrrecommend",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 76,
  },
  "mrresolution",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "mrunittest",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "mrdeveloper",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
  "mrtestresults",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "mrtester",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 32 },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:amjbHDsxLDSszpu6BKFJsg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
