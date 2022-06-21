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

	#--------------------------- SELINUX CONFIG ----------------------------#

	# Disable SELinux
	SELINUX_FILE=/etc/sysconfig/selinux
	if [ -f "$SELINUX_FILE" ]; then
		sed "s/^SELINUX=.*/SELINUX=disabled/" /etc/sysconfig/selinux >> /etc/sysconfig/aux_selinux
		rm /etc/sysconfig/selinux
		mv /etc/sysconfig/aux_selinux /etc/sysconfig/selinux
	else 
	    echo "$SELINUX_FILE does not exist. Can't configure it."
	    exit 1
	fi

	#------------------ /ETC/COBBLER/SETTINGS.YAML CONFIG -------------------#

	# Password Encryptation Step
	echo "default_password_crypted: \"$(openssl passwd -1 vagrant)\"" >> /etc/cobbler/passwd.txt
	sed "s/^default_password_crypted:.*/$(cat /etc/cobbler/passwd.txt)/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	rm /etc/cobbler/passwd.txt

	COBBLER_FILE=/etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't configure it."
	    exit 1
	fi

	# Manage_DHCP = true
	sed "s/^manage_dhcp:.*/manage_dhcp: true/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set Manage_DHCP to true."
	    exit 1
	fi	

	# Manage_DHCP_v4 = true
	sed "s/^manage_dhcp_v4:.*/manage_dhcp_v4: true/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set Manage_DHCP_v4 to true."
	    exit 1
	fi	

	# Configuration of next_server_v4 IP
	sed "s/^next_server_v4:.*/next_server_v4: 192.168.56.27/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set IP to next_server_v4 parameter."
	    exit 1
	fi

	# Configuration of server IP
	sed "s/^server:.*/server: 192.168.56.27/" /etc/cobbler/settings.yaml >> /etc/cobbler/aux.yaml
	if [ -f "$COBBLER_FILE" ]; then
	    rm /etc/cobbler/settings.yaml
			mv /etc/cobbler/aux.yaml /etc/cobbler/settings.yaml
	else 
	    echo "$COBBLER_FILE does not exist. Can't set IP to server parameter."
	    exit 1
	fi

	#------------------ /ETC/COBBLER/DHCP.TEMPLATE CONFIG -------------------#

	DHCP_FILE=/etc/cobbler/aux.template

	# Subnet Configuration
	sed "s/^subnet 172.168.0.0 netmask.*/subnet 192.168.56.27  netmask 255.255.255.0 {/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change the subnet parameter."
	    exit 1
	fi

	# Option Routers Configuration
	sed "s/^option routers.*/option routers             192.168.56.27;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change option routers IP."
	    exit 1
	fi

	# Option Domain Name Configuration
	sed "s/^option domain-name-servers.*/option domain-name-servers 192.168.56.27;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change option domain-name-servers."
	    exit 1
	fi

	# range dynamic-bootp Configuration
	sed "s/^range dynamic-bootp.*/range dynamic-bootp        192.168.56.100 172.168.10.254;/" /etc/cobbler/dhcp.template >> /etc/cobbler/aux.template
	if [ -f "$DHCP_FILE" ]; then
	    rm /etc/cobbler/dhcp.template
			mv /etc/cobbler/aux.template /etc/cobbler/dhcp.template
	else 
	    echo "$DHCP_FILE does not exist. Can't change range dynamic-bootp."
	    exit 1
	fi


	#----------------- /ETC/COBBLER/DNSMASQ.TEMPLATE CONFIG -----------------#

	DNSMASQ_FILE=/etc/cobbler/aux_dns.template

	# DHCP-RANGE Configuration
	sed "s/^dhcp-range=.*/dhcp-range=192.168.56.100,192.168.56.254/" /etc/cobbler/dnsmasq.template >> /etc/cobbler/aux_dns.template
	if [ -f "$DNSMASQ_FILE" ]; then
	    rm /etc/cobbler/dnsmasq.template
			mv /etc/cobbler/aux_dns.template /etc/cobbler/dnsmasq.template
	else 
	    echo "$DNSMASQ_FILE does not exist. Can't change rdhcp-range."
	    exit 1
	fi


	# Queda restart de servizos + check + sync

else
  echo "Error: ${COBLLER_DIR} not found. Can not continue."
  exit 1
fi

