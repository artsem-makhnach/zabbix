# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  
  config.vm.box = "centos-7.4-x86_64-minimal.box"
  
  
  config.vm.define "zabbix-server" do |srv|
	srv.vm.hostname = "zabbix-server"
	srv.vm.network "private_network", ip: "192.168.56.10"
	srv.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true
	
	srv.vm.provision "shell", path: "zabbix-server.sh"
  end

  config.vm.define "zabbix-client" do |srv|
	srv.vm.hostname = "zabbix-client"
	srv.vm.network "private_network", ip: "192.168.56.11"
	srv.vm.provision "shell", inline: <<-SHELL
		yum install -y http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm  	
		yum install -y zabbix-agent
		systemctl start zabbix-agent
		sed -i '/DebugLevel=/a DebugLevel=3' /etc/zabbix/zabbix_agentd.conf
		sed -i 's/Server=127.0.0.1/Server=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
		sed -i '/StartAgents=/a StartAgents=3' /etc/zabbix/zabbix_agentd.conf
		sed -i '/ListenIP=/a ListenIP=192.168.56.11' /etc/zabbix/zabbix_agentd.conf
		sed -i '/ListenPort=/a ListenPort=10050' /etc/zabbix/zabbix_agentd.conf
		sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.56.10/' /etc/zabbix/zabbix_agentd.conf
		sed -i 's/Hostname=Zabbix server/Hostname=zabbix-client/' /etc/zabbix/zabbix_agentd.conf
		
		systemctl restart zabbix-agent
  	SHELL
  end

# sed -i 's/Hostname=Zabbix server/Hostname=zabbix-server/' /etc/zabbix/zabbix_agentd.conf
  # config.vm.provision "shell", path:"fix.sh"
	



  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
