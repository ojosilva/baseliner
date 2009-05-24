package Baseliner::Schema::Harvest::Result::Harapprovelist;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harapprovelist");
__PACKAGE__->add_columns(
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
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
  "harstateprocess",
  "Baseliner::Schema::Harvest::Result::Harstateprocess",
  { processobjid => "processobjid", stateobjid => "stateobjid" },
);
__PACKAGE__->belongs_to(
  "usrobjid",
  "Baseliner::Schema::Harvest::Result::Haruser",
  { usrobjid => "usrobjid" },
);
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VKHWLtXMTx3dk07/wdfeJQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
