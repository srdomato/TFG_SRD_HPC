# Rocky Linux 8 Kickstart
# Basic setup information
url --url http://192.168.1.2/cobbler/ks_mirror/

network --bootproto=dhcp --device=link --activate --onboot=on
rootpw --lock --iscrypted locked
selinux --enforcing

# Language
keyboard es
lang en_US.UTF-8
timezone Europe/Madrid

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

# Package setup
%packages --ignoremissing --excludedocs --instLangs=en --nocore --excludeWeakdeps

@base
@console-internet
@core
@debugging
@directory-client
@hardware-monitoring
@java-platform
@large-systems
@network-file-system-client
@performance
@perl-runtime
@server-platform
@server-policy
@workstation-policy
oddjob
sgpio
device-mapper-persistent-data
pax
samba-winbind
certmonger
pam_krb5
krb5-workstation
perl-DBD-SQLite

bash
coreutils-single
glibc-minimal-langpack
systemd
microdnf
rocky-release

-brotli
-dosfstools
-e2fsprogs
-firewalld
-fuse-libs
-gettext*
-gnupg2-smime
-grub\*
-hostname
-iptables
-iputils
-kernel
-kexec-tools
-less
-libss
-os-prober*
-pinentry
-qemu-guest-agent
-rootfiles
-shared-mime-info
-tar
-trousers
-vim-minimal
-xfsprogs
-xkeyboard-config
-yum

%end
