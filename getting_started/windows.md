---
label: Install on Windows (Vagrant)
icon: /images/windows_os_logo_icon.png
order: 200
---

## Installing on Windows 10 and above
Developers can try out Kontain on Windows 10 Pro or above using any virtualization software that can run Linux with a modern Kernel version greater than 4.15.  Below we show  one of the easier ways to do this using Vagrant from HashiCorp software.

### Pre-requisite: turn on Hyper-V
You need to have nested virtualization turned on in your BIOS to be able to install Vagrant.

You also need to turn on Hyper-V as Vagrant will use the built-in Hyper-V's virtualization capabilities.

To turn on Hyper-V virtualization in Windows, you may need to go to the Control Panel, and use the "Turn on Windows features".  Please see the screenshots below.

![Turn on Windows Features](/images/windows-features.png)

![Turn on Hyper-V](/images/hyper-v.png)

### Installing Vagrant on Windows 10
To install the 64-bit version of Vagrant, you need to download it and install from [here](https://www.vagrantup.com/downloads).


### Run Vagrant VM
After installing Vagrant, we can now use it to run a Ubuntu 18.04 Linux VM.

To run a Vagrant VM, you need to first launch the Windows Command Prompt in Administrative mode as shown in the screenshot below:
![starting cmd terminal](/images/run_cmd_prompt.jpg)


Below we show the steps we use to run a Vagrant VM with Kontain on Windows:

```bash
C:\Users\user> mkdir kontain
C:\Users\user> cd kontain
C:\Users\user\kontain> curl -o VagrantFile  https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_win

# this initializes a Vagrantfile with the appropriate vm that gets auto-provisioned with Kontain
C:\Users\user\kontain> vagrant up
....

# a Vagrant VM is starts up with Kontain and docker pre-installed
# now you can ssh into it
C:\Users\user\kontain> vagrant ssh

# now that you are in the vagrant bash prompt. Let's switch to root
vagrant $ sudo -i

# run the kontain example to verify Kontain install
root # /opt/kontain/bin/km /opt/kontain/tests/hello_test.km Hello, Kontain!
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

Hopefully, this gets you started on trying out Kontain on Windows and using Vagrant.

Please note that if you want to test out Kontain with docker-compose on Vagrant, please see the instructions in the [Vagrantfile](https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_win).

### The Vagrantfile
Here is the [link](https://raw.githubusercontent.com/kontainapp/guide/main/_vagrantfiles/vagrantfile_win) to the Vagrantfile used to create a self-provisioning Vagrant VM with Kontain installed.