use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Module::Manage' }
BEGIN { use_ok 'Test::WWW::Mechanize::Catalyst' => 'Maximus' }

my $req = request('/modules');
ok($req->is_redirect, 'Request should redirect');

# Authenticate
my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok('/account/login', 'Request login page');
$ua1->submit_form(
    fields => {
        username => 'demouser',
        password => 'demodemo',
    }
);
$ua1->content_contains('Welcome demouser!', 'Login successful');

$ua1->get_ok('/modules', 'Request module manage page');
$ua1->content_contains('<h1>Module Management</h1>', 'Title check');

$ua1->get_ok('/module/new', 'Request add module page');
$ua1->content_contains('<h1>Edit Module</h1>', 'Title check');
$ua1->submit_form(
    fields => {
        scope  => 'foo',
        name   => 'bar',
        desc   => 'test description',
    }
);
$ua1->content_contains('Your Module configuration has been stored',
    'Module saved');
$ua1->content_contains('<h2>foo</h2>',
    'Successfully added module (scope check)');
$ua1->content_contains('<strong>bar</strong>',
    'Successfully added module (name check)');
$ua1->content_contains('<em>test description</em>',
    'Successfully added module (description check)');

$ua1->get_ok('/module/foo/bar/edit', 'Request edit module page');
$ua1->content_contains('<h1>Edit Module</h1>', 'Title check');
$ua1->submit_form(
    fields => {desc => 'modified test description'});
$ua1->content_contains('Your Module configuration has been stored',
    'Module saved');
$ua1->content_contains('<em>modified test description</em>',
    'Successfully edited module');

done_testing();
