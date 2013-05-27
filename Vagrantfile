# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use CentOS by default
  config.vm.box = "centos"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  ##############################
  #### Config for VM: router ###
  ##############################
  config.vm.define :router do |router|
    router.vm.provider "virtualbox" do |v|
      v.name = "Router"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan0"]
      v.customize ["modifyvm", :id, "--nic3", "intnet", "--intnet3", "lan1"]
      v.customize ["modifyvm", :id, "--nic4", "intnet", "--intnet4", "lan2"]
    end

    # Basic networking
    router.vm.hostname = "router"
    router.vm.network :forwarded_port, guest: 22, host: 22022

    # Provision router
    router.vm.provision :chef_solo do |chef|
      chef.add_recipe "router"
      chef.add_recipe "dhcp::relay"
      chef.add_recipe "tools"
    end
  end

  ##############################
  #### Config for VM: server ###
  ##############################
  config.vm.define :server do |server|
    server.vm.provider "virtualbox" do |v|
      v.name = "Sede: Servidor"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan0"]
    end

    # Basic networking
    server.vm.hostname = "server"
    server.vm.network :forwarded_port, guest: 22, host: 22000

    # Provision server
    server.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking::server"
      chef.add_recipe "dhcp::server"
      chef.add_recipe "tools"
    end
  end

  ##############################
  #### Config for VM: client ###
  ##############################
  config.vm.define :client do |client|
    client.vm.provider "virtualbox" do |v|
      v.name = "Sede: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan0", "--macaddress2", "080027FC3BCD"]
    end

    # Basic networking
    client.vm.hostname = "client"
    client.vm.network :forwarded_port, guest: 22, host: 22001

    # Provision server
    client.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking::client"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: client (filial 1) ###
  #########################################
  config.vm.define :client_f1 do |client_f1|
    client_f1.vm.provider "virtualbox" do |v|
      v.name = "Filial 1: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan1","--macaddress2", "0800276BE691"]
    end

    # Basic networking
    client_f1.vm.hostname = "filial1"
    client_f1.vm.network :forwarded_port, guest: 22, host: 22011

    # Provision server
    client_f1.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking::client"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: server (filial 2) ###
  #########################################
  config.vm.define :server2 do |server2|
    server2.vm.provider "virtualbox" do |v|
      v.name = "Filial 2: Servidor"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan2"]
    end

    # Basic networking
    server2.vm.hostname = "server2"
    server2.vm.network :forwarded_port, guest: 22, host: 22020

    # Provision server
    server2.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking::server2"
      chef.add_recipe "dhcp::server2"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: client (filial 2) ###
  #########################################
  config.vm.define :client_f2 do |client_f2|
    client_f2.vm.provider "virtualbox" do |v|
      v.name = "Filial 2: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "lan2"]
    end

    # Basic networking
    client_f2.vm.hostname = "filial2"
    client_f2.vm.network :forwarded_port, guest: 22, host: 22021

    # Provision server
    client_f2.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking::client"
      chef.add_recipe "tools"
    end
  end
end
