---
label: Install on Windows (Vagrant)
icon: /images/windows_os_logo_icon.png
order: 995
---

## Installing on Windows 10 and above
Developers can try out Kontain on Windows Desktop Pro using any virtualization software that can run Linux with a modern Kernel version greater than 4.15.  Below we show  one of the easier ways to do this using Vagrant from HashiCorp software.

### Pre-requisite for installing Vagrant
You need to have nested virtualization turned on in your BIOS to be able to install Vagrant.

You also need to turn on Hyper-V as Vagrant will use the built-in Hyper-V's virtualization capabilities.

To turn on Hyper-V virtualization in Windows, you may need to go to the Control Panel, and use the "Turn on Windows features".  Please see the screenshots below.

![Turn on Windows Features](/images/windows-features.png)

![Turn on Hyper-V](/images/hyper-v.png)

### Installing Vagrant on Windows 10
To install the 64-bit version of Vagrant, you need to download it and install from [here](https://www.vagrantup.com/downloads).


### Run Vagrant VM
After installing Vagrant, we can now use it to run a Ubuntu 20.10 Linux VM.

To run a Vagrant VM, you can download
![starting cmd terminal](/images/run_cmd_prompt.jpg)


```bash
C:\Users\user> mkdir ubuntu
C:\Users\user> cd ubuntu
C:\Users\user\ubuntu> cd ubuntu
C:\Users\user\ubuntu> vagrant init generic/ubuntu2010

# this initializes a Vagrantfile with the appropriate