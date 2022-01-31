---
label: Install on Mac (Vagrant)
icon: /images/macos_logo.png
order: 980
---

## Installing on Mac OS X
Developers can try out Kontain on Mac OS X using any virtualization software that can run Linux with a modern Kernel version greater than 4.15.  Below we show  one of the easier ways to do this using Vagrant from HashiCorp software.

### Pre-requisite for installing Vagrant
At this point, you need to have a computer capable of Nested Virtualization.

You also need to turn on [Nested Virtualization in VirtualBox](https://ostechnix.com/how-to-enable-nested-virtualization-in-virtualbox/)

### Installing Vagrant on the Mac OS X
To install the 64-bit version of Vagrant, you need to download it and install:

```bash
$ brew install vagrant
```

If you want more details on installing Vagrant they are [here](https://www.vagrantup.com/downloads).

### Run Kontain in Ubuntu
After installing Vagrant, we can now use it to run a Ubuntu 18.04 Linux VM 
that will automatically install the latest version of Kontain.

Below we show the steps we use to launch a Vagrant VM with Kontain:

```sh
$ mkdir kontain
$ cd kontain
$ curl -o VagrantFile  https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_mac

# this initializes a Vagrantfile with the appropriate vm that gets auto-provisioned with Kontain
$ vagrant up
....

# a Vagrant VM is starts up with Kontain and docker pre-installed
# now you can ssh into it
$ vagrant ssh

# now that you are in the vagrant bash prompt. Let's switch to root
vagrant $ sudo -i

# run the kontain example to verify Kontain install
root $# /opt/kontain/bin/km /opt/kontain/tests/hello_test.km 

Hello, Kontain!
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

Hopefully, this gets you started on trying out Kontain on the Mac using Vagrant.

Please note that if you want to test out Kontain with docker-compose on Vagrant, please see the instructions in the [Vagrantfile](https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_mac).

### The Vagrantfile
Here is the [link](https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_mac) to the Vagrantfile used to create a self-provisioning Vagrant VM with Kontain installed.