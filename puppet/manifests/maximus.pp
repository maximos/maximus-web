Exec { path => "/usr/local/bin/:/bin/:/usr/bin/:/sbin:/usr/sbin/" }

node default {
    include params
    include maximus
}

