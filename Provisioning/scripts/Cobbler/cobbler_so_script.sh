#!/bin/bash
sudo dnf install syslinux-tftpboot -y

sudo cp /tftpboot/* /var/lib/tftpboot


sudo chmod 777 /etc/cobbler/
sudo chmod 777 /etc/cobbler/*

sudo systemctl stop firewalld.service 


sudo systemctl enable tftp.socket
sudo systemctl restart tftp

sudo cobbler mkloaders

sudo wget https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.6-x86_64-minimal.iso
sudo mount -t iso9660 -o loop,ro Rocky-8.6-x86_64-minimal.iso /mnt
sudo cobbler import --name=Rocky-8-x86_64 --arch=x86_64 --path=/mnt
sudo cobbler distro report --name=Rocky-8-x86_64
sudo cobbler system add --name=Rocky-8-Desktop --profile=Rocky-8-x86_64
sudo cobbler system edit --name=Rocky-8-Desktop --ip-address=192.168.1.100 --netmask=255.255.255.0 --mac=00:11:22:AA:BB:CC --static=1 --gateway=192.168.1.2

sudo systemctl restart httpd.service 
sudo systemctl restart tftp.service 
sudo systemctl restart dhcpd
sudo systemctl restart xinetd.service 
sudo systemctl restart cobblerd.service 
