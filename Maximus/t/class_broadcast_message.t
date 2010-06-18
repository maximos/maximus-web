use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }

my $msg = new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello')]);
can_ok($msg, qw(text));
is($msg->text, 'Hello', 'Text matches');

done_testing();
