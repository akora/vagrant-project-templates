#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

print_header "Version checks"

packages=(python git node npm bower)

for package_to_check in ${packages[@]}; do
  if [[ "$package_to_check" = "python" ]]; then
    version="$(echo `python -c 'import sys; print(sys.version[:5])'`)"
    print_message_with_param $package_to_check $version
    indicator_green
  elif [[ "$package_to_check" = "git" ]]; then
    version="$(echo `git --version` | awk '{print $3}')"
    print_message_with_param $package_to_check $version
    indicator_green
  else
    version="$(echo `$package_to_check -v`)"
    if [[ "$version" =~ "v" ]]; then
      version="$(echo $version | cut -c2-)"
      print_message_with_param $package_to_check $version
      indicator_green
    else
    print_message_with_param $package_to_check $version
    indicator_green
    fi
  fi
done

exit 0
