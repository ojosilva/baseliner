package Baseliner::Schema::Harvest::Result::Harusdgroupnames;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harusdgroupnames");
__PACKAGE__->add_columns(
  "groupname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 40,
  },
  "groupuuid",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tq/0zGhEQRuSR/IVGUJing


# You can replace this text with custom content, and it will be preserved on regeneration
1;
