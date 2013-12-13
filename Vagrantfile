Vagrant.configure("2") do |config|
  config.vm.box = "puppet1204"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.hostname = "drupal.dev"
222
  config.vm.network :private_network, ip: "33.33.33.10"
    config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.synced_folder "./sites", "/var/www", :nfs => true
  config.vm.provision :shell, :inline => "sudo apt-get update"
  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      "ssh_username" => "vagrant"
    }

    puppet.manifests_path = "manifests"
    puppet.options = ["--verbose", "--hiera_config /vagrant/hiera.yaml"]
  end

  config.ssh.username = "vagrant"
end
