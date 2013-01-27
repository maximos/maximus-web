#!/usr/bin/env perl
use strict;
use local::lib;
use Daemon::Control;

$ENV{HOME} = '/vagrant';

Daemon::Control->new(
    {   name         => 'Maximus-Docs',
        path         => '/vagrant/script/init.d/maximus-docs.pl',
        directory    => '/vagrant/docs',
        program      => 'http_this',
        program_args => ['--port', 3002],
        user         => 'vagrant',
        group        => 'vagrant',
        fork         => 2,
        pid_file     => '/tmp/maximus-docs.pid',
        stdout_file  => '/vagrant/maximus-docs.log',
        stderr_file  => '/vagrant/maximus-docs.log',
        lsb_start    => '$syslog $network',
        lsb_stop     => '$syslog',
        lsb_sdesc    => 'Maximus-Docs script',
        lsb_desc     => 'Maximus-Docs script',
    }
)->run;

