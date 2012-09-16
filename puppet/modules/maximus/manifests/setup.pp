class maximus::setup {

    package { ["build-essential",
            "gearman-job-server",
            "git-core",
            "subversion",
            "libmodule-install-perl",
            "libcrypt-ssleay-perl",
            "libdbd-mysql-perl",
            "libmysqlclient-dev",
            "libxml2-dev",
            "libexpat1-dev",
            "coffeescript",
            ]:
        ensure => present,
        require => Exec['apt_update'],
    }

    group { "puppet":
        ensure => present,
    }

    file { '/etc/motd':
        content => "Vagrant built virtual server for Maximus"
    }

    service { "gearman-job-server":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => Package['gearman-job-server'],
    }

    exec { "apt_update":
        command => "apt-get update",
    }

    exec { "cpanm":
        command => "cpanp install --skiptest --force App::cpanminus",
        unless => "which cpanm",
    }

    exec { "perltidy":
        command => "cpanm -n Perl::Tidy",
        unless => "which perltidy",
    }

    exec { "catalyst_devel":
        command => "cpanm -n Catalyst::Devel",
        require => Exec['cpanm'],
        timeout => 0,
        unless => "which catalyst.pl"
    }

    exec { "mojolicious":
        command => "cpanm -n Mojolicious",
        require => Exec['cpanm'],
        unless => "which mojo"
    }

    exec { "daemon_control":
        command => "cpanm -n Daemon::Control",
        require => Exec['cpanm'],
        timeout => 0,
    }

    exec { "maximus_dependencies":
        command => "cpanm -n --installdeps .",
        timeout => 0,
        cwd => "/vagrant",
        require => Exec['catalyst_devel'],
    }

    exec { "maximus_server":
        command => "perl script/init.d/maximus_server.pl start",
        cwd => "/vagrant",
        require => [
                Exec['maximus_dependencies', 'maximus-sql'],
                File['maximus_server.pl'],
            ]
    }

    exec { "maximus_worker":
        command => "perl script/init.d/maximus_worker.pl start",
        cwd => "/vagrant",
        require => [
                Exec['maximus_dependencies', 'maximus-sql'],
                File['maximus_worker.pl'],
            ]
    }

    exec { "maximus_mojo":
        command => "perl script/init.d/maximus_mojo.pl start",
        cwd => "/vagrant",
        require => [
                Exec['maximus_dependencies', 'maximus-sql'],
            ]
    }

    file { "/vagrant/maximus.conf":
        content => template("maximus/maximus.conf.erb"),
    }

    file { "maximus_server.pl":
        path => "/vagrant/script/init.d/maximus_server.pl",
        source => "${params::filepath}/maximus/files/maximus_server.pl",
        ensure => present,
        require => File['/vagrant/script/init.d'],
    }

    file { "maximus_worker.pl":
        path => "/vagrant/script/init.d/maximus_worker.pl",
        source => "${params::filepath}/maximus/files/maximus_worker.pl",
        ensure => present,
        require => File['/vagrant/script/init.d'],
    }

    file { "maximus_mojo.pl":
        path => "/vagrant/script/init.d/maximus_mojo.pl",
        source => "${params::filepath}/maximus/files/maximus_mojo.pl",
        ensure => present,
        require => File['/vagrant/script/init.d'],
    }

    file { "/vagrant/script/init.d":
        ensure => "directory",
    }
}
