
### How to use the set of skeleton files included

Rename the `project-name` folder. The name of this folder will be included in the full name of the VirtualBox VM created by Vagrant.

The `code` folder is the location where your project code will be placed. This is part of the shared folder structure between your host OS and the VM. (Check the `Vagrantfile` for more details.) This folder is empty by default.

The `vagrant-scripts` folder contains helper shell scripts to prepare your new VM.

**NOTE:** the `BASE_BOX = "vagrant-debian-wheezy-32"` is referencing my locally created clean install Vagrant box. You can safely replace this line with another Debian 7 base box.

### Steps to take in order

#### Edit the `Vagrantfile`

Change the VM name (replace vm0x with a valid number), then give the IP address a valid ending:

```
VIRTUAL_MACHINES = [
  { :hostname => "vm0x.#{DOMAIN}",
    :ip => "192.168.100.10x",
    :box => BASE_BOX,
    :ram => 512 }
]
```

Leave the rest untouched.

#### Edit the `vagrant-scripts/bootstrap.sh` file

Add more must-have packages to the line

```
apt-get install -y vim htop <list of further must-have packages>
```

#### Extend the `vagrant-scripts/version-checks.sh` file

...as you install more and more packages.

Example:

```
print_message_with_param "Python" "`python -c 'import sys; print(sys.version[:5])'`" "\n"
# print_message_with_param "Node.js" "`node -v`" "\n"
# print_message_with_param "NPM" "`npm -v`" "\n"
```

These version checks will run each time you SSH to the VM. (The script gets included in the `.profile` file upon the first run of `bootstrap.sh`)

#### Tested on

* Debian 7.8 (wheezy)
