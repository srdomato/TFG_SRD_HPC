#!/bin/bash
sudo wget https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.0-x86_64-minimal.iso
sudo mount -t iso9660 -o loop,ro Rocky-9.0-x86_64-minimal.iso /mnt
sudo cobbler import --name=Rocky-9 --arch=x86_64 --path=/mnt