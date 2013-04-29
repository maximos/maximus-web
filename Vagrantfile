# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box     = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    config.vm.network :forwarded_port, guest: 3000, host: 3000  # For maximus_server.pl
    config.vm.network :forwarded_port, guest: 3001, host: 3001  # For maximus_mojo.pl
    config.vm.network :forwarded_port, guest: 3002, host: 3002  # For maximus_docs.pl
    config.vm.network :forwarded_port, guest: 3306, host: 33060 # For MySQL, change bind-address in
                                                                # /etc/mysql/my.cnf to 0.0.0.0 to use it
    config.vm.network :forwarded_port, guest: 5432, host: 54320 # For PostgreSQL

    config.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.customize ["modifyvm", :id, "--memory", 512]
    end

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path    = "puppet/modules"
        puppet.manifest_file  = "maximus.pp"
        puppet.options = [
            "--verbose",
            #"--debug",
            ]
    end
end
