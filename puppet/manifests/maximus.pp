Exec { path => "/usr/local/bin/:/bin/:/usr/bin/:/sbin:/usr/sbin/" }

class params {
    $dbname = 'maximus'
    $dbuser = 'maximus'
    $dbpass = 'demo'

    $filepath = '/vagrant/puppet/modules'

    $upload_transport = 'ftp'
    #$upload_transport = 'filesystem'

    $recaptcha = false
}

node default {
    include params
    include maximus
}

