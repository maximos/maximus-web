#!/usr/bin/env perl
use strict;
use local::lib;
use Daemon::Control;

$ENV{HOME} = '/vagrant';

Daemon::Control->new(
    {   name         => 'Maximus-Server',
        path         => '/vagrant/script/init.d/maximus-server.pl',
        directory    => '/vagrant',
        program      => '/usr/bin/perl',
        program_args => ['script/maximus_server.pl', '-r', '-d'],
        user         => 'vagrant',
        group        => 'vagrant',
        fork         => 2,
        pid_file     => '/tmp/maximus-server.pid',
        stdout_file  => '/vagrant/maximus-server.log',
        stderr_file  => '/vagrant/maximus-server.log',
        lsb_start    => '$syslog $network',
        lsb_stop     => '$syslog',
        lsb_sdesc    => 'Maximus-Server script',
        lsb_desc     => 'Maximus-Server script',
    }
)->run;


