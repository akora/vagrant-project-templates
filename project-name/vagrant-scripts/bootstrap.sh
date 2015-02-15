#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

HOSTNAME=$(hostname -f)
OS_RELEASE=$(lsb_release -sd)
IP_ADDRESS=$(/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

shared_dir="/home/vagrant/shared"

apt-get -q update
apt-get install -y vim htop
apt-get clean

# shell-utils.sh print_header does not work here... TODO: fix it!
printf "********************* Basic SysInfo -- $IP_ADDRESS *********************\n"
print_message "$OS_RELEASE" "\n"

print_message "Enabling color prompt..."
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/vagrant/.bashrc

print_message "Adding version checks script to .profile..."
if grep -Fxq "$shared_dir/vagrant-scripts/version-checks.sh" /home/vagrant/.profile
then
  print_message "Version checks script already added to .profile..." "\n"
else
  echo "$shared_dir/vagrant-scripts/version-checks.sh" >> /home/vagrant/.profile
fi

exit 0
