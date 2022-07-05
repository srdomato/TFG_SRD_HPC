sudo dnf -y install https://yum.puppet.com/puppet6-release-el-8.noarch.rpm
sudo dnf -y install https://yum.theforeman.org/releases/2.5/el8/x86_64/foreman-release.rpm

sudo yum install @ruby:2.7 -y
sudo dnf module reset ruby -y
sudo dnf module enable ruby:2.7 -y

sudo dnf update -y

sudo dnf -y install foreman-installer
sudo foreman-installer -v