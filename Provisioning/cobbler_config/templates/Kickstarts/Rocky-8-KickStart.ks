# Sample kickstart file for current EL, Fedora based distributions.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
repo --name=source-1 --baseurl=http://192.168.1.2/cobbler/distro_mirror/Rocky-8-x86_64/BaseOS
repo --name=source-2 --baseurl=http://192.168.1.2/cobbler/distro_mirror/Rocky-8-x86_64/Minimal

# Network information
network --bootproto=dhcp --device=eth0 --onboot=on  

# Reboot after installation
reboot

#Root password
rootpw --iscrypted $1$C8wD.d/N$4df2/5cyim7XYDXeOAOob0
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
autopart

%pre
set -x -v
exec 1>/tmp/ks-pre.log 2>&1

# Once root's homedir is there, copy over the log.
while : ; do
    sleep 10
    if [ -d /mnt/sysimage/root ]; then
        cp /tmp/ks-pre.log /mnt/sysimage/root/
        logger "Copied %pre section log to system"
        break
    fi
done &


curl "http://192.168.1.2/cblr/svc/op/trig/mode/pre/profile/Rocky-8-x86_64" -o /dev/null

# Enable installation monitoring

%end

%packages
%end

%post --nochroot
set -x -v
exec 1>/mnt/sysimage/root/ks-post-nochroot.log 2>&1

%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1

# Start yum configuration
curl "http://192.168.1.2/cblr/svc/op/yum/profile/Rocky-8-x86_64" --output /etc/yum.repos.d/cobbler-config.repo

# End yum configuration



# Start post_install_network_config generated code
# End post_install_network_config generated code

# Start download cobbler managed config files (if applicable)
# End download cobbler managed config files (if applicable)

# Start koan environment setup
echo "export COBBLER_SERVER=192.168.1.2" > /etc/profile.d/cobbler.sh
echo "setenv COBBLER_SERVER 192.168.1.2" > /etc/profile.d/cobbler.csh
# End koan environment setup

# begin Red Hat management server registration
# not configured to register to any Red Hat management server (ok)
# end Red Hat management server registration

# Begin cobbler registration
# cobbler registration is disabled in /etc/cobbler/settings.yaml
# End cobbler registration

# Enable post-install boot notification

# Start final steps

curl "http://192.168.1.2/cblr/svc/op/autoinstall/profile/Rocky-8-x86_64" -o /root/cobbler.ks
curl "http://192.168.1.2/cblr/svc/op/trig/mode/post/profile/Rocky-8-x86_64" -o /dev/null
# End final steps
%end
