use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Role::Transport' }

{

    package TestDriver;
    use Moose;
    with 'Maximus::Role::Transport';

    sub transport { }
    1;
}

can_ok('TestDriver', qw(transport base_url));
my $driver = new_ok('TestDriver' => [(base_url => '/')]);

done_testing();

