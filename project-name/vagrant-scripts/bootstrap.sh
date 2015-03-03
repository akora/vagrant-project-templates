#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

HOSTNAME=$(hostname -f)
OS_RELEASE=$(lsb_release -sd)
OS_ARCH=$(uname -m)
IP_ADDRESS=$(/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

shared_dir="/home/vagrant/shared"

apt-get -qq update
apt-get install -y vim htop mc curl software-properties-common python-software-properties

if [ ${OS_ARCH} == 'x86_64' ]; then
  OS_ARCHITECTURE="64-bit"
else
  OS_ARCHITECTURE="32-bit"
fi

# shell-utils.sh print_header does not work here... TODO: fix it!
printf "\n"
printf "********************* Basic SysInfo -- $IP_ADDRESS *********************\n"
print_message "$OS_RELEASE ($OS_ARCHITECTURE)" "\n"

print_message "Enabling color prompt..."
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/vagrant/.bashrc

if grep -Fxq "$shared_dir/vagrant-scripts/version-checks.sh" /home/vagrant/.profile
then
  print_message "Version checks script already added to .profile..." "\n"
else
  print_message "Adding version checks script to .profile..."
  echo "$shared_dir/vagrant-scripts/version-checks.sh" >> /home/vagrant/.profile
fi
