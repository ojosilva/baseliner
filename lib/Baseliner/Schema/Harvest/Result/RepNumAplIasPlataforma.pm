package Baseliner::Schema::Harvest::Result::RepNumAplIasPlataforma;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("rep_num_apl_ias_plataforma");
__PACKAGE__->add_columns(
  "plataforma",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 4 },
  "numero de aplicaciones ias",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 1,
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cQVA2kmcRocCxQ4xmJLgQA


# You can replace this text with custom content, and it will be preserved on regeneration
1;
