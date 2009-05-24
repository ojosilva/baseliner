package Baseliner::Schema::Harvest::Result::FormPaqueteRs;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("form_paquete_rs");
__PACKAGE__->add_columns(
  "rs_env",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "rs_elemento",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 4000,
  },
  "rs_fullname",
  {
    data_type => "VARCHAR2",
    default_value => undef,
    is_nullable => 1,
    size => 4000,
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-18 14:07:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EIvidzjF7xHhX2Ipfc1wWg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
