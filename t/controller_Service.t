use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Baseliner' }
BEGIN { use_ok 'Baseliner::Controller::Service' }

ok( request('/service')->is_success, 'Request should succeed' );


