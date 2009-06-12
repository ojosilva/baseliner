package Baseliner::Schema::Baseliner::Result::BaliCalendarWindow;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("bali_calendar_window");
__PACKAGE__->add_columns(
  "id",
  { data_type => "NUMBER", default_value => 1, is_nullable => 0, size => 126 },
  "start_time",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "end_time",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "day",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "type",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 1,
  },
  "active",
  {
    data_type => "VARCHAR2",
    default_value => "'1'\n",
    is_nullable => 1,
    size => 1,
  },
  "id_cal",
  { data_type => "NUMBER", default_value => "1 ", is_nullable => 0, size => 126 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "id_cal",
  "Baseliner::Schema::Baseliner::Result::BaliCalendar",
  { id => "id_cal" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-06-10 12:25:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yBf4Wbw07rIN/E4hRFfa4A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
