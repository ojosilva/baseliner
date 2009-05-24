package Baseliner::Schema::Baseliner::Result::BaliCalendar;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_calendar");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "ns",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "bl",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "start",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "end",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "day",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "type",
  { data_type => "VARCHAR", is_nullable => 0, size => undef },
  "active",
  { data_type => "CHAR", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-13 11:52:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fHVfqUowmEutFO9J40mUfg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
