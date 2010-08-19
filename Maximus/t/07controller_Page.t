use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Page' }

ok(request('/client')->is_success, 'Request should succeed');
ok(request('/faq')->is_success,    'Request should succeed');
ok(request('/foo')->is_error,      'Request should fail');

done_testing();
