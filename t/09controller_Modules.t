use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Modules' }

ok(request('/modules')->is_success, 'Request should succeed');
done_testing();
