#!/bin/bash
COBLLER_DIR=/etc/cobbler/
if [ -d "$COBLLER_DIR" ]; then

	#--------------------------- FIREWALL CONFIG ---------------------------#

	# TFTP
	/sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 69 -j ACCEPT
	/sbin/iptables -A INPUT -m state --state NEW -m udp -p udp --dport 69 -j ACCEPT

	# HTTPD
	/sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
	/sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

	# COBBLER
	/sbin/iptables -A INPUT -m state --state NEW -m udp -p udp --dport 25150 -j ACCEPT
	/sbin/iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 25150 -j ACCEPT

	/sbin/iptables-save

	#--------------------------- SELINUX CONFIG -----------------------------#

	# # Disable SELinux
	# SELINUX_FILE=/etc/sysconfig/selinux
	# if [ -f "$SELINUX_FILE" ]; then
	# 	sed "s/^SELINUX=.*/SELINUX=disabled/" /etc/sysconfig/selinux >> /etc/sysconfig/aux_selinux
	# 	rm /etc/sysconfig/selinux
	# 	mv /etc/sysconfig/aux_selinux /etc/sysconfig/selinux
	# else 
	#     echo "$SELINUX_FILE does not exist. Can't configure it."
	#     exit 1
	# fi

	setenforce 0

#---------------------------- SERVICES ------------------------------------#

	# Restarting Services
	sudo systemctl start xinetd
	sudo systemctl start httpd
	sudo systemctl start cobblerd

	# Enabling Services 
	sudo systemctl enable cobblerd
	sudo systemctl enable xinetd
	sudo systemctl enable httpd


	#------------------ /ETC/COBBLER/SETTINGS.YAML CONFIG -------------------#

	echo "------------- COBBLER SETTINGS CONFIGURATION -------------"

	# Backup File for settings.yaml
	cp /etc/cobbler/settings.yaml /etc/cobbler/backup.yaml

	# Password Encryptation Step
	echo "Password Encryptation Step"
	echo "default_password_crypted: \"$(openssl passwd -1 vagrant)\"" >> /etc/cobbler/passwd.txt
	sed "s/^default_password_crypted:.*/$(cat /etc/cobbler/passwd.txt)/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	rm /etc/cobbler/passwd.txt

	COBBLER_FILE=/etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't configure it."
	    mv /etc/cobbler/backup.yaml /etc/cobbler/settings.yaml
	    exit 1
	fi

	# Manage_DHCP = true
	echo "Manage DHCP to true"
	sed "s/^manage_dhcp:.*/manage_dhcp: true/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set Manage_DHCP to true."
	    mv /etc/cobbler/backup.yaml /etc/cobbler/settings.yaml
	    exit 1
	fi	

	# Manage_DHCP_v4 = true
	echo "Manage DHCPv4 to true"
	sed "s/^manage_dhcp_v4:.*/manage_dhcp_v4: true/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set Manage_DHCP_v4 to true."
	    mv /etc/cobbler/backup.yaml /etc/cobbler/settings.yaml
	    exit 1
	fi	

	# Configuration of next_server_v4 IP
	echo "IP Configuration next_server_v4"
	sed "s/^next_server_v4:.*/next_server_v4: 192.168.56.27/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set IP to next_server_v4 parameter."
	    mv /etc/cobbler/backup.yaml /etc/cobbler/settings.yaml
	    exit 1
	fi

	# Configuration of server IP
	echo "IP Configuration next_server"
	sed "s/^server:.*/server: 192.168.56.27/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set IP to server parameter."
	    mv /etc/cobbler/backup.yaml /etc/cobbler/settings.yaml
	    exit 1
	fi

	# #------------------ /ETC/COBBLER/DHCP.TEMPLATE CONFIG -------------------#
	echo "------------- DHCP TEMPLATE CONFIGURATION -------------"

  DHCP_FILE=/etc/cobbler/aux.template

	# Backup for dhcp.template
	cp /etc/cobbler/dhcp.template /etc/cobbler/backup_dhcp.template

	# Subnet Configuration
	echo "Subnet Configuration"
	sed "s/^subnet 192.168.1.0 netmask.*/subnet 192.168.56.0  netmask 255.255.255.0 {/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change the subnet parameter."
	    mv /etc/cobbler/backup_dhcp.template /etc/cobbler/dhcp.template
	    exit 1
	fi

  # Option Routers Configuration
  echo "Option routers Configuration"
  sed "s/option routers             192.*/option routers             192.168.56.27;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
  if [ -f "$DHCP_FILE" ]; then
      rm /etc/cobbler/dhcp.template
  		mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
  else 
      echo "$DHCP_FILE does not exist. Can't change option routers IP."
      mv /etc/cobbler/backup_dhcp.template /etc/cobbler/dhcp.template
      exit 1
  fi

  # Option Domain Name Configuration
  echo "Option domain-name-servers Configuration"
  sed "s/option domain-name-servers 192.*/option domain-name-servers 192.168.56.27;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
  if [ -f "$DHCP_FILE" ]; then
      rm /etc/cobbler/dhcp.template
  		mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
  else 
      echo "$DHCP_FILE does not exist. Can't change option domain-name-servers."
      mv /etc/cobbler/backup_dhcp.template /etc/cobbler/dhcp.template
      exit 1
  fi

	# range dynamic-bootp Configuration
	echo "Range dynamic-bootp Configuration"
	sed "s/range dynamic-bootp        192.*/range dynamic-bootp        192.168.56.100 192.168.56.254;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change range dynamic-bootp."
	    mv /etc/cobbler/backup_dhcp.template /etc/cobbler/dhcp.template
	    exit 1
	fi

	# #----------------- /ETC/COBBLER/DNSMASQ.TEMPLATE CONFIG -----------------#
	echo "------------- DNSMASQ TEMPLATE CONFIGURATION -------------"

	DNSMASQ_FILE=/etc/cobbler/aux_dns.template

	# Backup for dhcp.template
	cp /etc/cobbler/dnsmasq.template /etc/cobbler/backup_dnsmasq.template

	# DHCP-RANGE Configuration
	echo "DHCP RANGE Configuration"
	sed "s/^dhcp-range=.*/dhcp-range=192.168.56.100,192.168.56.254/" /etc/cobbler/dnsmasq.template >> /etc/cobbler/aux_dns.template
	if [ -f "$DNSMASQ_FILE" ]; then
	    rm /etc/cobbler/dnsmasq.template
			mv /etc/cobbler/aux_dns.template /etc/cobbler/dnsmasq.template
	else 
	    echo "$DNSMASQ_FILE does not exist. Can't change dhcp-range."
	    mv /etc/cobbler/backup_dnsmasq.template /etc/cobbler/dnsmasq.template
	    exit 1
	fi

	rm /etc/cobbler/backup.yaml
	rm /etc/cobbler/backup_dnsmasq.template
	rm /etc/cobbler/backup_dhcp.template

	echo "------------- RESTARTING SERVICES -------------"
	# Restarting Services
	systemctl restart xinetd
	systemctl restart httpd
	systemctl restart cobblerd

	# Enabling Services 
	systemctl enable cobblerd
	systemctl enable xinetd
	systemctl enable httpd

	echo "------------- COBBLER UPDATES -------------"
	# Cobbler Checks
	sudo cobbler check 
	sudo cobbler sync
else
  echo "Error: ${COBLLER_DIR} not found. Can not continue."
  exit 1
fi

