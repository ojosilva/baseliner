use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Baseliner' }
BEGIN { use_ok 'Baseliner::Controller::Namespace' }

ok( request('/namespace')->is_success, 'Request should succeed' );


