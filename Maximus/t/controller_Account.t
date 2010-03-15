use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Account' }

ok( request('/account')->is_success, 'Request should succeed' );
done_testing();
