use strict;
use warnings;
use local::lib;
use lib './lib';
use Maximus;

Maximus->setup_engine('PSGI');
my $app = sub { Maximus->run(@_) };
