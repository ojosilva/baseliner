package Baseliner::Schema::Harvest::Result::Harnotifylist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harnotifylist");
__PACKAGE__->add_columns(
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "parentprocobjid",
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
  "isgroup",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "usrobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
  "usrgrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
);
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);
__PACKAGE__->belongs_to(
  "harlinkedprocess",
  "Baseliner::Schema::Harvest::Result::Harlinkedprocess",
  {
    parentprocobjid => "parentprocobjid",
    processobjid    => "processobjid",
  },
);
__PACKAGE__->belongs_to(
  "usrobjid",
  "Baseliner::Schema::Harvest::Result::Haruser",
  { usrobjid => "usrobjid" },
);
__PACKAGE__->belongs_to(
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P9LaAtzxVpTxcuYkW/r2jw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
