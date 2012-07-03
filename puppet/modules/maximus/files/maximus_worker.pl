#!/usr/bin/env perl
use strict;
use local::lib;
use Daemon::Control;

$ENV{HOME} = '/vagrant';

Daemon::Control->new(
    {   name         => 'Maximus-Worker',
        path         => '/vagrant/script/init.d/maximus-worker.pl',
        directory    => '/vagrant',
        program      => '/usr/bin/perl',
        program_args => ['script/maximus_worker.pl', '--verbose'],
        user         => 'vagrant',
        group        => 'vagrant',
        fork         => 2,
        pid_file     => '/tmp/maximus-worker.pid',
        stdout_file  => '/vagrant/maximus-worker.log',
        stderr_file  => '/vagrant/maximus-worker.log',
        lsb_start    => '$syslog $network',
        lsb_stop     => '$syslog',
        lsb_sdesc    => 'Maximus-Worker script',
        lsb_desc     => 'Maximus-Worker script',
    }
)->run;

