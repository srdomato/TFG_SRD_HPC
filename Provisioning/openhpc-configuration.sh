dnf config-manager --set-enabled powertools
dnf -y install http://repos.openhpc.community/OpenHPC/2/CentOS_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm

dnf  -y update --refresh
yum -y install lua
dnf -y --enablerepo=powertools install lua-posix
dnf -y --enablerepo=powertools install lua-filesystem
