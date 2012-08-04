use local::lib;
use Daemon::Control;

$ENV{HOME} = '/vagrant';

Daemon::Control->new(
    {   name         => 'Maximus-Mojo',
        path         => '/vagrant/script/init.d/maximus-mojo.pl',
        directory    => '/vagrant',
        program      => '/usr/local/bin/morbo',
        program_args => ['--listen', 'http://*:3001', 'script/maximus_mojo.pl'],
        user         => 'vagrant',
        group        => 'vagrant',
        fork         => 2,
        pid_file     => '/tmp/maximus-mojo.pid',
        stdout_file  => '/vagrant/maximus-mojo.log',
        stderr_file  => '/vagrant/maximus-mojo.log',
        lsb_start    => '$syslog $network',
        lsb_stop     => '$syslog',
        lsb_sdesc    => 'Maximus-Mojo script',
        lsb_desc     => 'Maximus-Mojo script',
    }
)->run;


