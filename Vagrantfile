# -*- mode: ruby -*-
# vi: set ft=ruby :

MASTER_NODE_IP			= "192.168.56.27"
MASTER_NODE_MEM			= 4096
MASTER_NODE_CPUS		= 2
MASTER_NODE_HOSTNAME	= "MasterNode"	
MASTER_NODE_DISK_SIZE	= "15GB"

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
  config.vm.box = "generic/rocky8"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false
  config.vm.hostname = MASTER_NODE_HOSTNAME

  # Configure hostmanager and vbguest plugins
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", type: "dhcp"
  config.vm.network "private_network", ip: MASTER_NODE_IP, virtualbox__intnet: true

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./", "/vagrant"


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
      vb.memory = MASTER_NODE_MEM
      vb.cpus = MASTER_NODE_CPUS

      #filename = "./Disks/#{config.vm.hostname}-disk.vdi"
      #unless File.exist?(filename)
      #    vb.customize ["createmedium", "disk", "--filename", filename, "--format", "vdi", "--size", MASTER_NODE_DISK_SIZE * 1024]
      #end
      #vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", filename]
        
  end


  # Install ansible on the master node
  config.vm.provision "ansible_local" do |ansible|
      ansible.install = "true"
      ansible.install_mode = "pip3"
      ansible.playbook = "Provisioning/playbook.yml"
  end

  #Configuration for Cobbler By Script
  #config.vm.provision "shell", path: "Provisioning/scripts/cobbler-configuration.sh"
  
  #Configuration for OpenHPC By Script
  #config.vm.provision "shell", path: "Provisioning/scripts/openhpc-configuration.sh"
  
  #Configuration for TheForeman By Script
  #config.vm.provision "shell", path: "Provisioning/scripts/foreman-configuration.sh"

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end