use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Module' }

ok(request('/module')->is_redirect, 'Redirect should succeed');

my $req = request('/module/sources/json');
ok($req->is_success, 'Request should succeed');
is($req->header('Content-Type'), 'application/json', 'Is JSON Response');

$req = request('/module/sources/xml');
ok($req->is_success, 'Request should succeed');
is($req->header('Content-Type'), 'text/xml', 'Is XML Response');

$req = request('/module/test/mod1');
ok($req->is_success, 'Request should succeed');
my $content = $req->content;
like($content, qr/Author\(s\): Christiaan Kras/i);
like($content, qr/License: MIT/i);
like($content, qr/History/i);
like($content, qr/1\.1\.15:/i);
like($content, qr/foo bar:/i);
like($content, qr/1\.1\.14:/i);
like($content, qr/baz:/i);
like($content, qr/foo bar baz:/i);

$req = request('/module/download/test/mod1/1.1.15');
ok($req->is_success,   'Request should succeed');
ok(!$req->is_redirect, 'Not a redirect');
is($req->header('Content-Type'), 'application/x-zip',    'Is a ZIP archive');
is($req->filename,               'test-mod1-1.1.15.zip', 'Filename match');

$req = request('/module/download/test/mod1/1.1.16');
ok($req->is_error, 'Non-existing module download');
is($req->code, 404, 'Proper 404 status code');

my $rs = Maximus->model('DB::ModuleVersion')->search({version => '1.1.15'});
my $version = $rs->first;
$version->update({remote_location => 'http://www.google.com'});

$req = request('/module/download/test/mod1/1.1.15');
ok($req->is_redirect, 'Request has been redirected');

like(get('/module/search'), qr/search for modules/i);
$content = get('/module/search/test/1');
like($content,                        qr/test\.mod1/i);
like($content,                        qr/my test module/i);
like(get('/module/search/abcdefg/1'), qr/no matching modules found/i);

done_testing();
