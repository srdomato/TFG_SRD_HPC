#!/bin/bash

cat /vagrant/pub_script/clave_sergio.pub >> /root/.ssh/authorized_keys 

for i in /home/* # iterate over all files in dir
do
	if [ -d "$i" ] # if it's a directory
	then
		touch authorized_keys
		cat /vagrant/pub_script/clave_sergio.pub >> "$i"/.ssh/authorized_keys 
	fi
done