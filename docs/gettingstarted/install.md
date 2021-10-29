# Install
#### Local
*Pre-requisites:* Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with virtualization enabled.  

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.  Note that this also assumes that your user has access to /dev/kvm.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine installed.

*To install the Kontain runtime use:*

```shell
curl -s https://raw.githubusercontent.com/kontainapp/km/latest/km-releases/kontain-install.sh | sudo bash
```

This installs the necessary files in your /opt/kontain directory and configures the Kontain runtime for docker and podman. It also executes a smoke test of the unikernel virtual machine.

#### Vagrant
To try out Kontain using an already prepped Vagrant VM see below:
- [Using a Vagrant VM with Kontain pre-installed](/gettingstarted/using_vagrant)

#### On AWS EC2
To try out Kontain on a VM without access to /dev/kvm (for example on AWS EC2), see below:
- Using the KKM module on AWS EC2