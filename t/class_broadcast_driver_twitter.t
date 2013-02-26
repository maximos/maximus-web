use strict;
use warnings;
use Test::More;
use Test::MockObject;
use 5.10.1;

BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Twitter' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }

BEGIN {
    my $mock = Test::MockObject->new;
    $mock->fake_module('Net::Twitter', update => sub { });
    $mock->fake_new('Net::Twitter');
    $mock->set_isa('Net::Twitter');
    $mock->mock('update', sub { return $_[1] });
}

my $nt = new_ok 'Net::Twitter' => [
    (   traits              => ['OAuth', 'API::REST'],
        consumer_key        => 'ck',
        consumer_secret     => 'cs',
        access_token        => 'at',
        access_token_secret => 'ats',
    )
];

# Construct driver with Net::Twitter object
my $driver =
  new_ok('Maximus::Class::Broadcast::Driver::Twitter' => [(nt => $nt)]);
isa_ok($driver->nt, 'Net::Twitter');

my $msg =
  new_ok('Maximus::Class::Broadcast::Message' =>
      [(text => '1st test of Maximus::Class::Broadcast::Driver::Twitter',)]);
ok($driver->say($msg), 'First test message sent OK');

# Let the driver construct the Net::Twitter object
my %auth = (
    consumer_key        => 'ck',
    consumer_secret     => 'cs',
    access_token        => 'at',
    access_token_secret => 'ats',
);

$driver = new_ok('Maximus::Class::Broadcast::Driver::Twitter' => [\%auth]);
isa_ok($driver->nt, 'Net::Twitter');

$msg =
  new_ok('Maximus::Class::Broadcast::Message' =>
      [(text => '2nd test of Maximus::Class::Broadcast::Driver::Twitter',)]);
ok($driver->say($msg), 'Second test message sent OK');
done_testing();
