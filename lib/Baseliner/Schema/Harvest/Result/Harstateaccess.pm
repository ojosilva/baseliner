package Baseliner::Schema::Harvest::Result::Harstateaccess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harstateaccess");
__PACKAGE__->add_columns(
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "usrgrpobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "updateaccess",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
  "updatepkgaccess",
  { data_type => "CHAR", default_value => "'N' ", is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("stateobjid", "usrgrpobjid");
__PACKAGE__->belongs_to(
  "usrgrpobjid",
  "Baseliner::Schema::Harvest::Result::Harusergroup",
  { usrgrpobjid => "usrgrpobjid" },
);
__PACKAGE__->belongs_to(
  "stateobjid",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { stateobjid => "stateobjid" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HcRvJsm0V583VfEsmvmwlw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
