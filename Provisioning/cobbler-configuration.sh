#!/bin/bash
DIR_COBBLER=/etc/cobbler/
if [ -d "$DIR_COBBLER" ]; then

	# Password Encryptation Step
	echo "default_password_crypted: \"$(openssl passwd -1 vagrant)\"" >> /etc/cobbler/passwd.txt
	sed "s/^default_password_crypted:.*/$(cat /etc/cobbler/passwd.txt)/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	#rm /etc/cobbler/passwd.txt

	FILE_AUX=/etc/cobbler/aux.yaml
	if [ -f "$FILE_AUX" ]; then
	    rm /etc/cobbler/settings.yaml
		mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$FILE does not exist. Can't configure Encrypted Password."
	    exit 1
	fi	
	
else
  echo "Error: ${DIR} not found. Can not continue."
  exit 1
fi