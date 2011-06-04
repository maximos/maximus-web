use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Timeline' }

ok(request('/timeline')->is_success, 'Request should succeed');

my $req = request('/timeline/rss');
ok($req->is_success, 'Request should succeed');
is($req->header('Content-Type'), 'application/rss+xml', 'Is RSS Response');

$req = request('/timeline/atom');
ok($req->is_success, 'Request should succeed');
is($req->header('Content-Type'), 'application/atom+xml', 'Is Atom Response');

done_testing();
