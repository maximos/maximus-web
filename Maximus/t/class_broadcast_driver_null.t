use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Null' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }

my $driver = new_ok('Maximus::Class::Broadcast::Driver::Null');
is($driver->counter, 0, 'Counter = 0');

my $msg =
  new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello world!',)]);

$driver->say($msg);
is($driver->counter, 1, 'Counter = 1');

$driver->say($msg) for (1 .. 10);
is($driver->counter, 11, 'Counter = 11');

done_testing();
