# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use CentOS by default
  config.vm.box = "centos"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  # Config for VM: server
  config.vm.define :server do |server|

    # Set virtualbox to use an internal network
    # (second NIC created by the client.vm.network :private_network below)
    server.vm.provider "virtualbox" do |v|
      v.name = "Sede: Servidor"
      v.customize ["modifyvm", :id, "--nic2", "intnet"]
    end

    # Basic networking
    server.vm.hostname = "server"
    server.vm.network :private_network, ip: "172.16.0.1"

    # Provision server
    server.vm.provision :chef_solo do |chef|
      chef.add_recipe "vim"
      chef.add_recipe "dhcp"
    end
  end

  # Config for VM: client
  config.vm.define :client do |client|
    # Use Ubuntu Precise for the client
    client.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    # Set virtualbox to use an internal network
    # (second NIC created by the client.vm.network :private_network below)
    client.vm.provider "virtualbox" do |v|
      v.name = "Sede: cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet"]
    end

    # Basic netorking
    client.vm.hostname = "client"
    client.vm.network :private_network, type: :dhcp
  end
end
