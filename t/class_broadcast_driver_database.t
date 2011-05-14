use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Driver::Database' }
BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }

my $driver =
  new_ok('Maximus::Class::Broadcast::Driver::Database' =>
      [(model => Maximus->model('DB::Announcement'))]);

my $msg =
  new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello world!',)]);

my $row = $driver->say($msg);
isa_ok($row, 'DBIx::Class::Row');
is($row->message, $msg->text, 'Text match');
is($row->date,    $msg->date, 'DateTime match');

done_testing();
