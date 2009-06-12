package BaselinerX::Type::Namespace;
use Baseliner::Plug;
use Baseliner::Utils;
with 'Baseliner::Core::Registrable';

use YAML;
use Baseliner::Core::Namespace;

register_class 'namespace' => __PACKAGE__;

register 'namespace.root' => {
	name => 'Root Namespace',
	root => '/',
	handler => sub {
		return [ new Baseliner::Core::Namespace({
					ns      => '/',
					ns_name => 'root',
					ns_type => _loc( 'Root Namespace' ),
					ns_id   => 0,
					ns_parent => 0,
					ns_data => {},
				})
		];
	},
};
has 'name' 	=> ( is=> 'rw', isa=> 'Str' );
has 'root' 	=> ( is=> 'rw', isa=> 'Str' );
has 'mask' 	=> ( is=> 'rw', isa=> 'Str' );
has 'handler' => ( is=> 'rw', isa=> 'CodeRef' );
has 'can_job' => ( is=>'rw', isa=>'Bool', default=>0 );  ## can it be listed for jobs?

1;
