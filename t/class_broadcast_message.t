use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Class::Broadcast::Message' }

is(Maximus::Class::Broadcast::Message->MSG_TYPE_GENERAL,
    'general', 'type check');
is(Maximus::Class::Broadcast::Message->MSG_TYPE_MODULE,
    'module', 'type check');
is(Maximus::Class::Broadcast::Message->MSG_TYPE_AUTHOR,
    'author', 'type check');

my $msg = new_ok(
    'Maximus::Class::Broadcast::Message' => [
        (   text => 'Hello',
            type => Maximus::Class::Broadcast::Message->MSG_TYPE_MODULE,
            meta_data => {
                foo => 'bar',
                baz => 10,
            },
        )
    ]
);

can_ok($msg, qw(text date type meta_data));
is($msg->text, 'Hello', 'Text matches');
is( $msg->type,
    Maximus::Class::Broadcast::Message->MSG_TYPE_MODULE,
    'Message type matches'
);
isa_ok($msg->date, 'DateTime');
is($msg->meta_data->{foo}, 'bar', 'meta-data foo');
is($msg->meta_data->{baz}, 10, 'meta-data baz');

$msg = new_ok('Maximus::Class::Broadcast::Message' => [(text => 'Hello')]);
is( $msg->type,
    Maximus::Class::Broadcast::Message->MSG_TYPE_GENERAL,
    'Default type check'
);
is($msg->meta_data, undef, 'No meta-data');

done_testing();
