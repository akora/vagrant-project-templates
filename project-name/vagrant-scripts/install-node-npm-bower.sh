#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

print_header "Installing Node.js & npm & Bower"

print_message "Installing required dependencies first..." "\n"
apt-get install -y curl

print_message "Installing Node.js..." "\n"
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs

print_message "Upgrading npm to the latest version..." "\n"
npm install npm -g

print_message "Upgrading Node.js to the latest stable version..." "\n"
npm cache clean -f > /dev/null 2>&1
npm install -g n
n stable > /dev/null 2>&1

print_message "Installing Bower..." "\n"
npm install -g bower

print_message "Listing user-installed packages..." "\n"
npm list -g --depth=0

exit 0
