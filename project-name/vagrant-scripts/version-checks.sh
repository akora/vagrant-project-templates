#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

print_header "Version checks"
print_message_with_param "Python" "`python -c 'import sys; print(sys.version[:5])'`" "\n"
# print_message_with_param "Node.js" "`node -v`" "\n"
# print_message_with_param "NPM" "`npm -v`" "\n"

exit 0
