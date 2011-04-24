use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Broadcast::Announcer' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Null' }

my $announcer = new_ok('Maximus::Class::Broadcast::Announcer');
can_ok(
    $announcer, qw(
      addListener
      getListeners
      countListeners
      say
      )
);

is($announcer->countListeners, 0, '0 listeners');

my $driver = new_ok('Maximus::Class::Broadcast::Driver::Null');
$announcer->addListener($driver);
is($announcer->countListeners, 1, '1 listener');
is($driver->counter,           0, 'AnnounceTest counter = 0');

my $msg =
  new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello world!',)]);

isa_ok($announcer->say($msg), 'Maximus::Class::Broadcast::Message');
is($driver->counter, 1, 'AnnounceTest counter = 1');

isa_ok($announcer->say('Hello world!'), 'Maximus::Class::Broadcast::Message');
is($driver->counter, 2, 'AnnounceTest counter = 2');

isa_ok(
    $announcer->say(text => 'Hello world!'),
    'Maximus::Class::Broadcast::Message'
);
is($driver->counter, 3, 'AnnounceTest counter = 3');

$announcer->say('test') for (1 .. 10);
is($driver->counter, 13, 'AnnounceTest counter = 13');

done_testing();
