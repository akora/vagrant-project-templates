#!/usr/bin/env bash

# be careful with the source path below! it seems /vagrant/ is the path "inside" the VM!
source /vagrant/vagrant-scripts/shell-utils.sh

mysql_config_file="/etc/mysql/my.cnf"
mysql_root_password="root"

print_header "Installing MySQL"

install_mysql() {
  print_message "Installing MySQL server and setting root password..." "\n"
  debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"
  apt-get install -y mysql-client mysql-server
}

fix_config_file() {
  print_message "Fixing warnings about changed setting names in $mysql_config_file..." "\n"
  if grep -q "key_buffer_size" $mysql_config_file; then
    print_message "key_buffer_size found, nothing to do..."
    indicator_green
  else
    print_message "key_buffer_size..."  "\n"
    # replacing only the first occurrence
    sed -i '0,/key_buffer\s/s/key_buffer\s/key_buffer_size/' $mysql_config_file
  fi
  if grep -q "myisam-recover-options" $mysql_config_file; then
    print_message "myisam-recover-options found, nothing to do..."
    indicator_green
  else
    print_message "myisam-recover-options..."  "\n"
    sed -i 's/myisam-recover\s/myisam-recover-options/g' $mysql_config_file
  fi
}

allow_remote_access() {
  print_message "Allowing remote management of MySQL server..." "\n"
  if grep -q "0.0.0.0" $mysql_config_file; then
    print_message "0.0.0.0 found, nothing to do..."
    indicator_green
  else
    print_message "0.0.0.0..." "\n"
    sed -i 's/127.0.0.1/0.0.0.0/g' $mysql_config_file
  fi
  mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '$mysql_root_password';"
  mysql -uroot -proot -e "FLUSH PRIVILEGES;"
}

restart_service() {
  print_message "Restarting service for changes to take effect..." "\n"
  sudo service mysql restart
}

# main control flow

install_mysql
fix_config_file
allow_remote_access
restart_service

# all done

exit 0
