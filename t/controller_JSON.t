use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Baseliner' }
BEGIN { use_ok 'Baseliner::Controller::JSON' }

ok( request('/json')->is_success, 'Request should succeed' );


