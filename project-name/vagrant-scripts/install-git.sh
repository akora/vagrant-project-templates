#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

git_version="2.3.0" # << feel free to change it
git_global_user_name="<Your name goes here>"
git_global_email="<Your email address goes here>"

install_dir="/home/vagrant"

cd $install_dir

print_header "Installing Git"

print_message "Installing required dependencies first..." "\n"
apt-get install -y autoconf gettext libcurl4-gnutls-dev libexpat1-dev zlib1g-dev libssl-dev

print_message "Getting latest source code..." "\n"
wget https://github.com/git/git/archive/v$git_version.tar.gz
tar -zxf v$git_version.tar.gz

print_message "Compiling it..." "\n"
cd git-$git_version
make configure
./configure --prefix=/usr
make
make install

git --version

print_message "Setting global variables..." "\n"
sudo -u vagrant git config --global user.name "$git_global_user_name"
sudo -u vagrant git config --global user.email $git_global_email

# switching to the vagrant user to see the user's git config list
sudo -u vagrant git config --list

cd $install_dir

print_message "Cleaning up..." "\n"
rm -rf git-$git_version
rm v$git_version.tar.gz

exit 0
