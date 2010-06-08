#!/bin/env perl
use strict;
use local::lib;
use lib './lib';
use Maximus::Schema;

my $schema = Maximus::Schema->connect(
'dbi:mysql:maximus',
'maximus',
'demo',
);

if (!$schema->get_db_version()) {
	# schema is unversioned
	$schema->deploy();
} else {
	$schema->upgrade();
}
