class maximus::sql {
    include mysql

    exec { 'create-db':
        unless => "/usr/bin/mysql -u${params::dbuser} -p${params::dbpass} ${params::dbname}",
        command => "/usr/bin/mysql -e \"CREATE DATABASE ${params::dbname}; GRANT ALL ON ${params::dbname}.* TO ${params::dbuser}@localhost IDENTIFIED BY '${params::dbpass}';\"",
        require => Service["mysql"],
    }

    exec { "maximus-sql":
        command => "perl script/maximus_sql_upgrade.pl",
        cwd => "/vagrant",
        require => Exec['maximus_dependencies', 'create-db'],
        timeout => 0,
    }
}
