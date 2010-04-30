use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Module' }

ok( request('/module')->is_redirect, 'Redirect should succeed' );
ok( request('/module/sources/list')->is_success, 'Request should succeed' );

my $req = request('/module/sources/json');
ok( $req->is_success, 'Request should succeed' );
is( $req->header('Content-Type'), 'application/json', 'Is JSON Response' );

$req = request('/module/sources/xml');
ok( $req->is_success, 'Request should succeed' );
is( $req->header('Content-Type'), 'text/xml', 'Is XML Response' );

done_testing();
