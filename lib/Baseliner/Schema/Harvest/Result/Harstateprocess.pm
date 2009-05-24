package Baseliner::Schema::Harvest::Result::Harstateprocess;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("harstateprocess");
__PACKAGE__->add_columns(
  "stateobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processobjid",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "processname",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 128 },
  "processtype",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 32 },
  "processorder",
  {
    data_type => "NUMBER",
    default_value => undef,
    is_nullable => 0,
    size => 126,
  },
  "postcount",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
  "precount",
  { data_type => "NUMBER", default_value => "0 ", is_nullable => 0, size => 126 },
);
__PACKAGE__->set_primary_key("stateobjid", "processobjid");
__PACKAGE__->has_many(
  "harapproves",
  "Baseliner::Schema::Harvest::Result::Harapprove",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harapprovelists",
  "Baseliner::Schema::Harvest::Result::Harapprovelist",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harcheckinprocs",
  "Baseliner::Schema::Harvest::Result::Harcheckinproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harcheckoutprocs",
  "Baseliner::Schema::Harvest::Result::Harcheckoutproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harconmrgprocs",
  "Baseliner::Schema::Harvest::Result::Harconmrgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harcrpkgprocs",
  "Baseliner::Schema::Harvest::Result::Harcrpkgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harcrsenvmrgprocs",
  "Baseliner::Schema::Harvest::Result::Harcrsenvmrgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "hardelversprocs",
  "Baseliner::Schema::Harvest::Result::Hardelversproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "hardemoteprocs",
  "Baseliner::Schema::Harvest::Result::Hardemoteproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harintmrgprocs",
  "Baseliner::Schema::Harvest::Result::Harintmrgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harlinkedprocesses",
  "Baseliner::Schema::Harvest::Result::Harlinkedprocess",
  {
    "foreign.parentprocobjid" => "self.processobjid",
    "foreign.stateobjid"      => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harlistdiffprocs",
  "Baseliner::Schema::Harvest::Result::Harlistdiffproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harlistversprocs",
  "Baseliner::Schema::Harvest::Result::Harlistversproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harmovepkgprocs",
  "Baseliner::Schema::Harvest::Result::Harmovepkgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harnotifies",
  "Baseliner::Schema::Harvest::Result::Harnotify",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harnotifylists",
  "Baseliner::Schema::Harvest::Result::Harnotifylist",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harpromoteprocs",
  "Baseliner::Schema::Harvest::Result::Harpromoteproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harremitemprocs",
  "Baseliner::Schema::Harvest::Result::Harremitemproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harrenameitemprocs",
  "Baseliner::Schema::Harvest::Result::Harrenameitemproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harsnapviewprocs",
  "Baseliner::Schema::Harvest::Result::Harsnapviewproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->belongs_to(
  "stateobjid",
  "Baseliner::Schema::Harvest::Result::Harstate",
  { stateobjid => "stateobjid" },
);
__PACKAGE__->has_many(
  "harstateprocessaccesses",
  "Baseliner::Schema::Harvest::Result::Harstateprocessaccess",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harswitchpkgprocs",
  "Baseliner::Schema::Harvest::Result::Harswitchpkgproc",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);
__PACKAGE__->has_many(
  "harudps",
  "Baseliner::Schema::Harvest::Result::Harudp",
  {
    "foreign.processobjid" => "self.processobjid",
    "foreign.stateobjid"   => "self.stateobjid",
  },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2009-05-12 15:09:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:elGNisydk+h1YD1FBQBeLw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
