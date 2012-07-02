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

    exec { "maximus_dependencies":
        command => "cpanm -n --installdeps .",
        timeout => 0,
        cwd => "/vagrant",
        require => Exec['catalyst_devel'],
    }

    file { "/vagrant/maximus.conf":
        content => template("maximus/maximus.conf.erb"),
    }
}
