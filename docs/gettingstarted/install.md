# Install

*Pre-requisites:* Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with virtualization enabled.  

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine installed.

*To install the Kontain runtime use:*

```shell
curl -s https://raw.githubusercontent.com/kontainapp/km/latest/km-releases/kontain-install.sh | sudo bash
```

This installs the necessary files in your /opt/kontain directory and configures the Kontain runtime for docker and podman. It also executes a smoke test of the unikernel virtual machine.
