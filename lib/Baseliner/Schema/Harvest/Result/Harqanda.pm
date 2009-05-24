package Baseliner::Schema::Harvest::Result::Harqanda;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harqanda");
__PACKAGE__->add_columns(
  "formobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "answeredby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 44 },
  "submittedby",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 44 },
  "quesdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "ansdate",
  { data_type => "DATE", default_value => undef, is_nullable => 1, size => 19 },
  "queskeyword",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 66,
  },
  "answer",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
  "question",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 2000,
  },
);
__PACKAGE__->set_primary_key("formobjid");
__PACKAGE__->belongs_to(
  "formobjid",
  "Baseliner::Schema::Harvest::Result::Harform",
  { formobjid => "formobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1UrZmkbnD2E5QnOmGMnzjw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
