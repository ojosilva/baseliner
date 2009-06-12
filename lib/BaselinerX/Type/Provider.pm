package BaselinerX::Type::Provider;
use Baseliner::Plug;
with 'Baseliner::Core::Registrable';

register_class 'provider' => __PACKAGE__;

has 'id'=> (is=>'rw', isa=>'Str', default=>'');
has 'name' => ( is=> 'rw', isa=> 'Str' );
has 'desc' => ( is=> 'rw', isa=> 'Str' );
has 'list' => ( is=> 'rw', isa=> 'CodeRef' );
has 'config' => ( is=> 'rw', isa=> 'Str' );

1;

=head1 DESCRIPTION

Class for a registerable namespace provider.

=cut