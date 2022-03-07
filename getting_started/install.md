---
label: Install (in Docker)
icon: /images/docker.png
order: 1000
---

# Install
## Pre-requisites
Kontain runs on *Linux kernel version 4.15 or newer*, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled. For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.  Note that this also assumes that your user has access to /dev/kvm.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine is installed.

### check for pre-requisites
```shell
# verify that you have a 64-bit Linux kernel version 4.15 or higher
$ uname -m
x86_64
$ uname -r
5.14.14-200.fc34.x86_64

# verify that you have nested virtualization turned on
$ cat /proc/cpuinfo| egrep "vmx|svm" | wc -l
# output must be greater than 0

# verify that you have KVM already installed /dev/kvm enabled by checking:
$ ls -l /dev/kvm

# verify that Docker is installed
$ systemctl|grep docker.service
  docker.service                                                                            loaded active running   Docker Application Container Engine
```
##### Optional: Installing Docker in Fedora/RHEL systems
If Docker is not present, you can install Docker On Fedora/RHEL systems using [instructions from here](https://developer.fedoraproject.org/tools/docker/docker-installation.html) or for Ubuntu using these [instructions](https://docs.docker.com/engine/install/ubuntu/).

### install Kontain
```shell
# create the kontain folder for install
$ sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain

# download and install the latest Kontain release
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash

Pulling https://github.com/kontainapp/km/releases/download/v0.9.5/kontain.tar.gz...
Done.
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello'
Hello, argv[2] = 'World'
...
....
Complete!

/home/user/.config/containers/containers.conf does exist, checking its contents
init_path = "/usr/libexec/docker/docker-init" is already in /home/smijar/.config/containers/containers.conf

runtime krun already configured in /home/smijar/.config/containers/containers.conf
krun = [
        "/opt/kontain/bin/krun"
]
selinux not enabled on this system
krun already configured in /etc/docker/daemon.json
"krun": {
  "path": "/opt/kontain/bin/krun"
}

# check for Kontain in /opt/kontain folder
$ ls -l /opt/kontain
...
drwxr-xr-x 1 smijar  121 296 Nov 10 09:32 bin
drwxr-xr-x 1 smijar  121 140 Nov 10 09:32 lib
drwxr-xr-x 1 smijar  121 194 Nov 10 09:32 runtime
...

# This installed Kontain in /opt/kontain and added the Kontain runtime (/opt/bin/km) to docker. 
# This also executed a smoke test of the unikernel virtual machine.
```


### Verify Install
#### Verify that Kontain is installed
```shell
# check if Kontain Monitor is installed
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

#### In Docker:
```shell
# lets verify with Docker
$ cp /opt/kontain/tests/hello_test.km

# use a Dockerfile to bundle this simple program
$ cat Dockerfile
FROM scratch
ADD hello_test.km /
ENTRYPOINT ["/hello_test.km"]
CMD ["from", "docker"]

# build the image
$ docker build -t try-kontain .

# run with kontain as the runtime
$ docker run --runtime=krun --rm try-kontain:latest
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'

# this verifies that Kontain is being used as a runtime in Docker
```
