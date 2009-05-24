package BaselinerX::Type::Role;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

register_class 'role' => __PACKAGE__;

has 'id'=> (is=>'rw', isa=>'Str', default=>'');
has 'name' => ( is=> 'rw', isa=> 'Str' );



1;