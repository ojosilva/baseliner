package Baseliner::Schema::Harvest::Result::Harconversionlog;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harconversionlog");
__PACKAGE__->add_columns(
  "tablename",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "lastobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
);
__PACKAGE__->set_primary_key("tablename");


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5gnTGdYRukZtZ4uELHYA+g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
