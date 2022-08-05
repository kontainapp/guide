---
label: Install (Linux)
icon: /images/logo2.png
order: 1000
---

[!ref text="Examples" target=_blank](https://github.com/kontainapp/guide-examples/)
## Pre-requisites
Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally:

Ubuntu 20.04 or higher, or
Fedora 34 or higher, or
Amazon Linux 2 VM with kernel version 5.10 or higher.
Note that this also assumes that your user has access to /dev/kvm.

Kontain also runs on platforms that do not offer access to Nested Virtualization by using a Software Virtualization Module.

+++ checking for pre-requisites
```shell
# verify that you have a 64-bit Linux kernel version 4.15 or higher
$ uname -m
x86_64

$ uname -r
5.14.14-200.fc34.x86_64

# verify that you have nested virtualization turned on
$ cat /proc/cpuinfo| egrep "vmx|svm" | wc -l
# output must be atleast 1 or greater

# verify that you have KVM already installed /dev/kvm enabled by checking:
$ ls -l /dev/kvm

# verify that Docker is installed
$ systemctl|grep docker.service
  docker.service
```

==- Tip: Installing Docker on RHEL/Fedora, Amazon Linux 2 or Ubuntu systems
If Docker is not present, you can install Docker On Fedora/RHEL systems using [instructions from here](https://developer.fedoraproject.org/tools/docker/docker-installation.html) or for Ubuntu using these [instructions](https://docs.docker.com/engine/install/ubuntu/).
===

+++ Update your OS
To ensure a smooth install, we recommend updating your OS:
```shell
# For Fedora:
$ sudo dnf update -y

# For Ubuntu Focal:
$ sudo apt update -y

# For Amazon Linux 2:
$ sudo yum update -y
```

+++

## Install Kontain
```shell
# create the kontain folder for install
$ sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain

# download and install the latest Kontain release
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash
...

# This installed Kontain in /opt/kontain and added the Kontain runtime (/opt/bin/km) to docker in /etc/docker/daemon.json. 
# This also executed a smoke test of the unikernel virtual machine.

# check for Kontain in /opt/kontain folder
$ ls -l /opt/kontain
...
drwxr-xr-x 1 smijar  121 296 Nov 10 09:32 bin
drwxr-xr-x 1 smijar  121 140 Nov 10 09:32 lib
drwxr-xr-x 1 smijar  121 194 Nov 10 09:32 runtime
...
```

## Verify Kontain install
```shell
# check if Kontain monitor can run the unikernel
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km

# check if docker can run with kontain as runtime
$ docker run --runtime=krun kontainguide/hello-kontain
```

## Using Kontain with different Languages
+++ Java
```shell
$ docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

$ docker stop spring-boot-hello
```

For more details see [Using Kontain with Java](/getting_started/java)

For impelementation details, you can see:
[!ref target="blank" text="Java Examples"](https://github.com/kontainapp/guide-examples/tree/master/examples/java)

+++ Python
```shell
$ docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello kontainguide/py-flask-hello:1.0

$ curl -v http://localhost:5000

$ docker stop py-flask-hello
```

For more details see [Using Kontain with Python](/getting_started/python)

For impelementation details, you can see:
[!ref target="blank" text="Python Examples"](https://github.com/kontainapp/guide-examples/tree/master/examples/python)

+++ Go
```shell
$ $ docker run -d --rm -e "PORT=8080" -e "TARGET=Kontain" -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

# stop the service
$ docker stop golang-http-hello
```

For more details see [Using Kontain with Go](/getting_started/golang)

For impelementation details, you can see:
[!ref target="blank" text="Golang example"](https://github.com/kontainapp/guide-examples/tree/master/examples/go/golang-http-hello)

+++ Javascript/NodeJS
```shell
$ docker run -d --rm -p 8080:8080 --runtime=krun --name node-express-hello kontainguide/node-express-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

$ docker stop node-express-hello
```

For more details see [Using Kontain with Javascript/NodeJS](/getting_started/javascript)

For impelementation details, you can see:
[!ref target="blank" text="JS/NodeJS example"](https://github.com/kontainapp/guide-examples/tree/master/examples/js/node-express-hello)
+++

## Using examples for more details
You can see the [Kontain guide examples](https://github.com/kontainapp/guide-examples) for more details on how to use Kontain in Kubernetes and docker-compose.

```shell
$ git clone https://github.com/kontainapp/guide-examples.git
$ cd examples
````
