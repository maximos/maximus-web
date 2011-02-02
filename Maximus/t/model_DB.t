use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'Maximus' }
BEGIN { use_ok 'Maximus::Model::DB' }

my $user = Maximus->model('DB::User')->create({
    username => 'test',
    password => 'test',
    email => 'test@example.com',
});

is( $user->roles->first->role,
    'user-' . $user->id . '-mutable',
    'user-<id>-mutable role available'
);

done_testing();
