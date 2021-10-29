# Install
## Local
*Pre-requisites:* Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with virtualization enabled.  

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.  Note that this also assumes that your user has access to /dev/kvm.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine installed.

*To install the Kontain runtime use:*

```shell
curl -s https://raw.githubusercontent.com/kontainapp/km/latest/km-releases/kontain-install.sh | sudo bash
```

This installs the necessary files in your /opt/kontain directory and configures the Kontain runtime (/opt/bin/km) for docker and podman. It also executes a smoke test of the unikernel virtual machine.

## Vagrant
### Using Vagrant to try Kontain
To simplify trying out Kontain, we provide pre-configured VMs available (with km and kkm pre-installed) from Vagrant Cloud:

- Ubuntu 20.10 – https://app.vagrantup.com/kontain/boxes/ubuntu2010-kkm-beta3
- Fedora 32 – https://app.vagrantup.com/kontain/boxes/fedora32-kkm-beta3

You will need Vagrant (https://www.vagrantup.com) with VirtualBox provider (https://www.VirtualBox.org) installed on your machine.

Once the VM is up (vagrant init kontain/ubuntu2010-kkm-beta3; vagrant up) and logged in (vagrant ssh), you will have Kontain already installed and configured for use.

## On a Cloud VM - AWS EC2
To simplify running Kontain, we provide pre-configured AMIs available from AWS Marketplace.  This AMI already has Kontain KKM pre-installed so that you can try out the Kontain unikernel on AWS.
