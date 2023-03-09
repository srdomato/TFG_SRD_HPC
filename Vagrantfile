# -*- mode: ruby -*-
# vi: set ft=ruby :

MASTER_NODE_IP			 = "192.168.1.2"
MASTER_NODE_MEM			  = 8192
MASTER_NODE_CPUS		  = 2
MASTER_NODE_HOSTNAME	= "montoxo.dec.udc.es"	
MASTER_NODE_DISK_SIZE	= "32GB"
ISO_SERVER_IP         = "192.168.0.27"
INTERFACE_BRIDGE      = "eth0"
BRIDGE_HOST_IP        = "192.168.0.17"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documentiped and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Configure hostmanager and vbguest plugins
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true

  config.vm.define "mnode", primary: true do |mnode|

    mnode.vm.box = "generic/rocky8"

    mnode.ssh.username = 'root'
    mnode.ssh.password = 'vagrant123'


    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    mnode.vm.box_check_update = true
    mnode.vm.hostname = MASTER_NODE_HOSTNAME

    mnode.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    mnode.vm.network "forwarded_port", guest: 443, host: 8443, host_ip: "127.0.0.1"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    #config.vm.network "private_network", type: "dhcp"
    mnode.vm.network "public_network", :bridge => INTERFACE_BRIDGE ,ip: BRIDGE_HOST_IP
    #mnode.vm.network "public_network", :bridge => INTERFACE_BRIDGE ,ip: ISO_SERVER_IP
    mnode.vm.network "private_network", ip: MASTER_NODE_IP, virtualbox__intnet: true

    mnode.vm.synced_folder "./", "/vagrant"


    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    mnode.vm.provider "virtualbox" do |vb|
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
    mnode.vm.provision "ansible_local" do |ansible|
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



  # config.vm.define "node1" do |node1|
  #   node1.vm.box = 'empty'
  #   node1.vm.hostname = "node1"
  #   node1.network "public_network", :bridge => "eth0", mac: 001122334455
    
  #   node1.vm.provider "virtualbox" do |nd1|
  #     nd1.cpus = 2
  #     nd1.memory = 4096
  #     nd1.boot 'network'
  #     nd1.check_guest_additions = false

  #     # configure for PXE boot.
  #     nd1.customize ['modifyvm', :id, '--boot1', 'net']
  #     nd1.customize ['modifyvm', :id, '--boot2', 'disk']
  #     nd1.customize ['modifyvm', :id, '--biospxedebug', 'on']
  #     nd1.customize ['modifyvm', :id, '--cableconnected2', 'on']
  #     nd1.customize ['modifyvm', :id, '--nicbootprio2', '1']
  #     nd1.customize ['modifyvm', :id, "--nictype2", '82540EM'] # Must be an Intel card (as-of VB 5.1 we cannot Intel PXE boot from a virtio-net card).
  #   end

  # end
end