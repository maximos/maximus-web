use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Maximus::Role::Broadcast::Driver' }

{
	package TestDriver;
	use Moose;
	with 'Maximus::Role::Broadcast::Driver';

	sub init {}
	sub say {}
	1;
}

can_ok('TestDriver', qw(say));
my $driver = new_ok('TestDriver');

done_testing();
