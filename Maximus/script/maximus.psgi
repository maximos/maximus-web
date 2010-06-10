#!/usr/bin/env perl
use strict;
use warnings;
use local::lib;
use Maximus;

Maximus->setup_engine('PSGI');
my $app = sub { Maximus->run(@_) };
