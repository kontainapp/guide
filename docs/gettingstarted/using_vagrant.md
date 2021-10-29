# Using Vagrant to test Kontain
To simplify running Kontain, we provide pre-configured VMs available from Vagrant Cloud:

- Ubuntu 20.10 – https://app.vagrantup.com/kontain/boxes/ubuntu2010-kkm-beta3
- Fedora 32 – https://app.vagrantup.com/kontain/boxes/fedora32-kkm-beta3

You will need Vagrant (https://www.vagrantup.com) with VirtualBox provider (https://www.VirtualBox.org) installed on your machine.

Once the VM is up (vagrant init kontain/ubuntu2010-kkm-beta3; vagrant up) and logged in (vagrant ssh), you will have Kontain already installed and configured for use.
