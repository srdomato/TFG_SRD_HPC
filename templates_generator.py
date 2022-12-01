#!/usr/bin/python
import os
import yaml
from jinja2 import Template


# ---------------------- Vagrant ---------------------- 

with open("./Provisioning/vars/vagrant_vars.yml") as variables:
	doc = yaml.safe_load(variables)

with open("Vagrantfile_template") as VagrantTemplate:
    t = Template(VagrantTemplate.read())

output = t.render(
		MASTER_NODE_IP			= doc["variables"]["MASTER_NODE_IP"],
		MASTER_NODE_MEM			= doc["variables"]["MASTER_NODE_MEM"],
		MASTER_NODE_CPUS		= doc["variables"]["MASTER_NODE_CPUS"],
		MASTER_NODE_HOSTNAME	= doc["variables"]["MASTER_NODE_HOSTNAME"],
		MASTER_NODE_DISK_SIZE	= doc["variables"]["MASTER_NODE_DISK_SIZE"],
		ISO_SERVER_IP			= doc["variables"]["ISO_SERVER_IP"],
		INTERFACE_BRIDGE      	= doc["variables"]["INTERFACE_BRIDGE"],
		BRIDGE_HOST_IP        	= doc["variables"]["BRIDGE_HOST_IP"])


with open("Vagrantfile", "w") as Vagrantfile:
    Vagrantfile.write(output)

# ---------------------- Cobbler Settings ----------------------    
#
#with open("./Provisioning/cobbler_config/vars/settings_vars.yml") as variables:
#	doc = yaml.safe_load(variables)
#
#with open("./Provisioning/cobbler_config/templates/settings_t.yaml") as SettingsTemplate:
#    t = Template(SettingsTemplate.read())
#
#output = t.render(
#		DEFAULT_PASSWD 		= doc["variables"]["DEFAULT_PASSWD"],
#		MANAGE_DHCP			= doc["variables"]["MANAGE_DHCP"],
#		MANAGE_DHCP_V4		= doc["variables"]["MANAGE_DHCP_V4"],
#		MANAGE_DHCP_V6		= doc["variables"]["MANAGE_DHCP_V6"],
#		NEXT_SERVER_V4		= doc["variables"]["NEXT_SERVER_V4"],
#		NEXT_SERVER_V6		= doc["variables"]["NEXT_SERVER_V6"],
#		IPXE_VAR				= doc["variables"]["IPXE_VAR"],
#		SERVER 				= doc["variables"]["SERVER"])
#
#with open("./Provisioning/cobbler_config/settings.yaml", "w") as Settings:
#    Settings.write(output)
#
## ---------------------- Cobbler DHCP ----------------------    
#
#with open("./Provisioning/cobbler_config/vars/dhcp_vars.yml") as variables:
#	doc = yaml.safe_load(variables)
#
#with open("./Provisioning/cobbler_config/templates/dhcp_t.template") as DhcpTemplate:
#    t = Template(DhcpTemplate.read())
#
#output = t.render(
#		SUBNET					= doc["variables"]["SUBNET"],
#		OPTION_ROUTERS			= doc["variables"]["OPTION_ROUTERS"],
#		DOMAIN_NAME_SERVERS		= doc["variables"]["DOMAIN_NAME_SERVERS"],
#		RANGE_DYNAMIC_BOOTP		= doc["variables"]["RANGE_DYNAMIC_BOOTP"])
#
#with open("./Provisioning/cobbler_config/dhcp.template", "w") as Dhcp:
#    Dhcp.write(output)    
#
#
## ---------------------- Cobbler DNSMASQ ----------------------    
#
#with open("./Provisioning/cobbler_config/vars/dnsmasq_vars.yml") as variables:
#	doc = yaml.safe_load(variables)
#
#with open("./Provisioning/cobbler_config/templates/dnsmasq_t.template") as DnsTemplate:
#    t = Template(DnsTemplate.read())
#
#output = t.render( DHCP_RANGE = doc["variables"]["DHCP_RANGE"])
#
#with open("./Provisioning/cobbler_config/dnsmasq.template", "w") as Dns:
#    Dns.write(output)    