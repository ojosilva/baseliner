package Baseliner::Schema::Harvest::Result::Harallchildrenpath;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harallchildrenpath");
__PACKAGE__->add_columns(
  "itemobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "childitemid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("itemobjid", "childitemid");
__PACKAGE__->belongs_to(
  "itemobjid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "itemobjid" },
);
__PACKAGE__->belongs_to(
  "childitemid",
  "Baseliner::Schema::Harvest::Result::Haritems",
  { itemobjid => "childitemid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ABC9tkvm+RyZRx/lfBiwDA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
