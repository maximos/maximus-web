# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    # Boot with a GUI so you can see the screen. (Default is headless)
    # config.vm.boot_mode = :gui

    # Assign this VM to a bridged network, allowing you to connect directly to a
    # network using the host's network device. This makes the VM appear as another
    # physical device on your network.
    # config.vm.network :bridged

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    config.vm.forward_port 3000, 3000 # For maximus_server.pl
    config.vm.forward_port 3001, 3001 # For maximus_mojo.pl
    config.vm.forward_port 3306, 33060 # For MySQL, change bind-address in
                                       # /etc/mysql/my.cnf to 0.0.0.0 to use it
    config.vm.forward_port 22, 2222

    config.vm.customize ["modifyvm", :id, "--memory", 512]

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.manifest_file  = "maximus.pp"
        puppet.options = [
            "--verbose",
            #"--debug",
            ]
    end
end
