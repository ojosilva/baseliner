package Baseliner::Schema::Harvest::Result::Harpmstatus;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harpmstatus");
__PACKAGE__->add_columns(
  "pmstatusindex",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "pmstatusname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
);
__PACKAGE__->set_primary_key("pmstatusindex");
__PACKAGE__->has_many(
  "harstates",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { "foreign.pmstatusindex" => "self.pmstatusindex" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hJvjCidLEpsjL2AALKSHGA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
