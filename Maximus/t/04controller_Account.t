use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Account' }
BEGIN { use_ok 'Test::WWW::Mechanize::Catalyst' => 'Maximus' }

my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok('/account/signup', 'Request signup page');
$ua1->content_contains('<h2>Sign-Up</h2>', 'h2 check');
# Try a faulty signup
$ua1->submit_form();
$ua1->content_contains('You must enter a e-mail address', 'E-mail should be required');
$ua1->content_contains('You must enter a username', 'Username should be required');
$ua1->content_contains('You must enter a password', 'Password should be required');

$ua1->get_ok('/account/signup', 'Request signup page');
# Try to create account
my %data = (
	fields => {
		username => 'demo_user',
		password => 'demo',
		email => 'test@maximus.htbaa.com',
	}
);
$ua1->submit_form(%data);
$ua1->content_contains('Welcome demo_user!', 'Signing up successful');

# Logout
$ua1->get_ok('/account/logout', 'Request logout page');

# Try signing up again with the same details, which should fail
$ua1->get_ok('/account/signup', 'Request signup page');
$ua1->submit_form(%data);
$ua1->content_contains('Username already taken', 'Failed to sign-up');

$ua1->get_ok('/account/login', 'Request login page');
$ua1->content_contains('<h2>Login</h2>', 'h2 check');
# Try a faulty login
$ua1->submit_form(
	fields => {
		username => 'foo',
		password => 'bar',
	}
);
$ua1->content_contains('Bad username or password', 'Login should fail');

# Try a successful login
$ua1->submit_form(
	fields => {
		username => 'demo_user',
		password => 'demo',
	}
);
$ua1->content_contains('Welcome demo_user!', 'Login should succeed');

# Logout
$ua1->get_ok('/account/logout', 'Request logout page');

done_testing();
