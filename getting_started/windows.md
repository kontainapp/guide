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
C:\Users\user> mkdir kontain
C:\Users\user> cd kontain
C:\Users\user\kontain> cd kontain
C:\Users\user\kontain> curl -o VagrantFile  https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_win

# this initializes a Vagrantfile with the appropriate vm that gets auto-provisioned with Kontain
C:\Users\user\kontain> vagrant up
....

# now that a Vagrant VM is up and running you can ssh into it and try out all the kontain examples

# lets try out the simplest one
C:\Users\user\kontain> /opt/kontain/bin/km /opt/kontain/tests/hello_test.km Hello, Kontain!
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

Hopefully, this gets you started on trying out Kontain on Windows.