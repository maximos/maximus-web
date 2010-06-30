use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Controller::Account' }
BEGIN { use_ok 'Test::WWW::Mechanize::Catalyst' => 'Maximus' }
BEGIN { use_ok 'Digest::SHA', qw/sha1_hex/ }

my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok('/account/signup', 'Request signup page');
$ua1->content_contains('<h1>Sign-Up</h1>', 'h1 check');
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
		confirm_password => 'demo',
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
$ua1->content_contains('<h1>Login</h1>', 'h1 check');
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
		username => $data{fields}{username},
		password => $data{fields}{password},
	}
);
$ua1->content_contains('Welcome demo_user!', 'Login should succeed');

# Try to edit account details
$ua1->get_ok('/account/edit', 'Request edit account page');
$ua1->content_contains('<h1>Edit Account</h1>', 'h1 check');
$ua1->content_contains('id="email" value="'.$data{fields}{email}.'"', 'Check pre-filled form');
$ua1->submit_form(
	fields => {
		email => 'test2@maximus.htbaa.com',
		password => 'something_else',
		confirm_password => 'something_else',
	}
);
$ua1->content_contains('<h1>Your details have been updated</h1>', 'h1 check');
my $user = Maximus->model('DB::User')->find({username => $data{fields}{username}});
isnt($user->email, $data{fields}{email}, 'E-mail address changed');
isnt($user->password, sha1_hex($data{fields}{password}), 'Password changed');

# Logout
$ua1->get_ok('/account/logout', 'Request logout page');

# Forgot password form
$ua1->get_ok('/account/forgot_password', 'Request forgot password page');
$ua1->content_contains('<h1>Forgot your password?</h1>', 'h1 check');
$ua1->submit_form(
	fields => {
		username => $data{fields}{username},
	}
);
$ua1->content_contains('<h1>Confirmation e-mail sent</h1>', 'h1 check');
$ua1->content_contains('check your e-mail for instructions', 'Confirmation message');

$user = Maximus->model('DB::User')->find({username => $data{fields}{username}});
my $hash = sha1_hex( $user->password . Maximus->config->{salt} . $user->id );
my $faulty_hash = sha1_hex('test');

ok( request('/account/reset_password/' . $data{fields}{username} . '/' . $faulty_hash)->is_error, 'Faulty reset password link');

$ua1->get_ok('/account/reset_password/' . $data{fields}{username} . '/' . $hash, 'Request reset password page');
$ua1->content_contains('<h1>Your password has been reset</h1>', 'h1 check');
$ua1->content_contains('Your password has been reset', 'Password reset');

$ua1->get_ok('/account', 'Request account page');
$ua1->content_contains('Welcome demo_user!', 'Automatically logged in');

# Reset password for further usage
$user = Maximus->model('DB::User')->find({username => $data{fields}{username}});
$user->update({password => sha1_hex($data{fields}{password})});
is($user->password, sha1_hex($data{fields}{password}), 'Check password reset');

# Logout
$ua1->get_ok('/account/logout', 'Request logout page');

done_testing();
