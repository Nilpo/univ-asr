# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use CentOS by default
  config.vm.box = "centos"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  ####################################
  #### Config for VM: server (DMZ) ###
  ####################################
  config.vm.define :dmz do |dmz|
    dmz.vm.provider "virtualbox" do |v|
      v.name = "DMZ: Servidor"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "dmz", "--macaddress2", "080027FC3BCE"]
    end

    # Basic networking
    dmz.vm.hostname = "dmz"

    # Public access (Internet)
    dmz.vm.network :public_network, adapter: 3

    # Provision machine
    dmz.vm.provision :chef_solo do |chef|
      chef.json = {
        "static" => {
          "ip" => "172.31.0.1",
          "route" => "172.16.0.0/16 via 172.31.0.254",
          "resolv" => "domain",
          "nameservers" => ["172.31.0.1", "8.8.8.8"],
          "no_peerdns" => ["eth0", "eth2"],
        }
      }
      chef.add_recipe "networking"
      chef.add_recipe "dns"
      chef.add_recipe "tools"
    end
  end

  ##############################
  #### Config for VM: router ###
  ##############################
  config.vm.define :router do |router|
    router.vm.provider "virtualbox" do |v|
      v.name = "Router"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "sede"]
      v.customize ["modifyvm", :id, "--nic3", "intnet", "--intnet3", "filial1"]
      v.customize ["modifyvm", :id, "--nic4", "intnet", "--intnet4", "filial2"]
      v.customize ["modifyvm", :id, "--nic5", "intnet", "--intnet5", "dmz"]
    end

    # Basic networking
    router.vm.hostname = "router"

    # Provision machine
    router.vm.provision :chef_solo do |chef|
      chef.add_recipe "router"
      chef.add_recipe "networking::resolv"
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
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "sede"]
    end

    # Basic networking
    server.vm.hostname = "server"

    # Provision machine
    server.vm.provision :chef_solo do |chef|
      chef.json = {
        "static" => {
          "ip" => "172.16.0.1",
          "gateway" => "172.16.0.254",
        }
      }
      chef.add_recipe "networking"
      chef.add_recipe "dhcp"
      chef.add_recipe "tools"
    end
  end

  ##############################
  #### Config for VM: client ###
  ##############################
  config.vm.define :client do |client|
    client.vm.provider "virtualbox" do |v|
      v.name = "Sede: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "sede"]
    end

    # Basic networking
    client.vm.hostname = "client"

    # Provision machine
    client.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: client (filial 1) ###
  #########################################
  config.vm.define :client_f1 do |client_f1|
    client_f1.vm.provider "virtualbox" do |v|
      v.name = "Filial 1: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "filial1"]
    end

    # Basic networking
    client_f1.vm.hostname = "filial1"

    # Provision machine
    client_f1.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: server (filial 2) ###
  #########################################
  config.vm.define :server2 do |server2|
    server2.vm.provider "virtualbox" do |v|
      v.name = "Filial 2: Servidor"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "filial2"]
    end

    # Basic networking
    server2.vm.hostname = "server2"

    # Provision machine
    server2.vm.provision :chef_solo do |chef|
      chef.json = {
        "static" => {
          "ip" => "172.16.2.1",
          "gateway" => "172.16.2.254",
          "domain" => "imob.imbcc.pt",
        }
      }
      chef.add_recipe "networking"
      chef.add_recipe "dhcp"
      chef.add_recipe "tools"
    end
  end

  #########################################
  #### Config for VM: client (filial 2) ###
  #########################################
  config.vm.define :client_f2 do |client_f2|
    client_f2.vm.provider "virtualbox" do |v|
      v.name = "Filial 2: Cliente"
      v.customize ["modifyvm", :id, "--nic2", "intnet", "--intnet2", "filial2"]
    end

    # Basic networking
    client_f2.vm.hostname = "filial2"

    # Provision machine
    client_f2.vm.provision :chef_solo do |chef|
      chef.add_recipe "networking"
      chef.add_recipe "tools"
    end
  end
end
