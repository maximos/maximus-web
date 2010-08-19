use strict;
use warnings;
use Test::More;
use 5.10.1;

BEGIN {
    plan skip_all => 'Set TEST_TWITTER_USERNAME to run this test'
      unless defined($ENV{TEST_TWITTER_USERNAME});
    plan skip_all => 'Set TEST_TWITTER_PASSWORD to run this test'
      unless defined($ENV{TEST_TWITTER_PASSWORD});
}

BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Twitter' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }
BEGIN { use_ok 'Net::Twitter' }

my %auth = (
    username => $ENV{TEST_TWITTER_USERNAME},
    password => $ENV{TEST_TWITTER_PASSWORD},
);

my $nt = new_ok 'Net::Twitter' => [
    (   traits   => ['API::REST'],
        username => $auth{username},
        password => $auth{password},
    )
];

# Construct driver with Net::Twitter object
my $driver =
  new_ok('Maximus::Class::Broadcast::Driver::Twitter' => [(nt => $nt)]);
isa_ok($driver->nt, 'Net::Twitter');

my $msg =
  new_ok('Maximus::Class::Broadcast::Message' =>
      [(text => '1st test of Maximus::Class::Broadcast::Driver::Twitter',)]);
my $res = $driver->say($msg);
ok($res->{id}, 'First test message sent OK');
$driver->nt->destroy_status($res->{id});

# Let the driver construct the Net::Twitter object
$driver = new_ok('Maximus::Class::Broadcast::Driver::Twitter' => [\%auth]);
isa_ok($driver->nt, 'Net::Twitter');

$msg =
  new_ok('Maximus::Class::Broadcast::Message' =>
      [(text => '2nd test of Maximus::Class::Broadcast::Driver::Twitter',)]);
$res = $driver->say($msg);
ok($res->{id}, 'Second test message sent OK');
$driver->nt->destroy_status($res->{id});
done_testing();
