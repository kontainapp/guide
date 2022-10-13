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
!!!
Kontain also runs on platforms that do not offer access to Nested Virtualization by using a Software Virtualization Module.
!!!


+++ checking for pre-requisites
1. Verify that you have a 64-bit Linux kernel version 4.15 or higher
```shell
uname -r
```

The output will lool like the following 
:::custom-shell-output
```
5.14.14-200.fc34.x86_64
```
:::

2. verify that Docker is installed and running 
```shell
systemctl status docker
```
The output will look like 
:::custom-shell-output
```
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-10-10 11:12:42 MST; 1 day 22h ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 30042 (dockerd)
      Tasks: 38
     Memory: 11.1G
        CPU: 6min 3.380s
     CGroup: /system.slice/docker.service
             └─ 30042 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Oct 12 07:13:41 fc dockerd[30042]: time="2022-10-12T07:13:41.140880944-07:00" level=debug msg="Applying tar in /var/lib/docker/overlay2/ccdf8db5665a209a4630503f26bdf3f8e>
Oct 12 07:13:48 fc dockerd[30042]: time="2022-10-12T07:13:48.442110019-07:00" level=debug msg="Applied tar sha256:89b603e67eaf0f31ae0ffc6526d960d9807c6476745001e79bba49d>
Oct 12 07:13:49 fc dockerd[30042]: time="2022-10-12T07:13:49.737426859-07:00" level=debug msg="[BUILDER] Command to be executed: [/bin/sh -c #(nop)  CMD [\"/home/appuser>
```
:::

==- Tip: Enabling KVM for Ubuntu 20.04
To enable KVM for Ubuntu, you can see the [tips here](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-20-04/)
===
==- Tip: Installing Docker on RHEL/Fedora, Amazon Linux 2 or Ubuntu systems
If Docker is not present, you can install Docker On Fedora/RHEL systems using [instructions from here](https://developer.fedoraproject.org/tools/docker/docker-installation.html) or for Ubuntu using these [instructions](https://docs.docker.com/engine/install/ubuntu/).
===

+++ Update your OS
To ensure a smooth install, we recommend updating your OS:
- For Fedora:
```shell
sudo dnf update -y
```
- For Ubuntu Focal:
```shell
sudo apt update -y
```
- For Amazon Linux 2:
```shell
sudo yum update -y
```

+++

## Install Kontain
```shell
sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain
curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash
```

This installed Kontain in /opt/kontain directory and configured the Kontain runtime for docker (/etc/docker/daemon.json) and podman (~/.config/containers/containers.conf). 

This also executed a smoke test of the unikernel virtual machine.

## Verify Kontain Install
1. Check for Kontain in /opt/kontain folder
```shell
ls -l /opt/kontain
drwxr-xr-x   4 smijar  121   4096 Sep 16 18:03 alpine-lib
drwxr-xr-x   2 smijar  121   4096 Oct 10 16:20 bin
drwxr-xr-x   3 smijar  root   4096 Oct  5 17:10 config
drwxr-xr-x   7 smijar  121   4096 Sep 16 17:24 examples
drwxr-xr-x   2 smijar  121   4096 Sep 16 18:03 include
-rwxr-xr-x   1 smijar  121 370035 Sep 16 18:03 kkm.run
drwxr-xr-x   2 smijar  121   4096 Sep 16 18:03 lib
drwxr-xr-x   2 smijar  121   4096 Sep 16 18:03 runtime
drwxr-xr-x   2 smijar  root   4096 Oct  7 09:25 tests
```

2. Verify Kontain install
- check if Kontain monitor can run the unikernel
```shell
/opt/kontain/bin/km /opt/kontain/tests/hello_test.km
```
Output will look like 
:::custom-shell-output
```
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
```
:::

- check if docker can run with kontain as runtime
```shell
docker run --runtime=krun kontainguide/hello-kontain
```
Output will look like 
:::custom-shell-output
```
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'
```
:::
## Using Kontain with different Languages
+++ Java
```shell
docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello:1.0
# invoke the service
curl -v http://localhost:8080
# stop the service
docker stop spring-boot-hello
```

For more details see [Using Kontain with Java](/getting_started/java)

For impelementation details, you can see:
[!ref target="blank" text="Java Examples"](https://github.com/kontainapp/guide-examples/tree/master/examples/java)

+++ Python
```shell
docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello kontainguide/py-flask-hello:1.0
# invoke the service
curl -v http://localhost:5000
# stop the service
docker stop py-flask-hello
```

For more details see [Using Kontain with Python](/getting_started/python)

For impelementation details, you can see:
[!ref target="blank" text="Python Examples"](https://github.com/kontainapp/guide-examples/tree/master/examples/python)

+++ Go
```shell
docker run -d --rm -e "PORT=8080" -e "TARGET=Kontain" -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello:1.0
#invoke the service
curl -v http://localhost:8080
#stop the service
docker stop golang-http-hello
```

For more details see [Using Kontain with Go](/getting_started/golang)

For impelementation details, you can see:
[!ref target="blank" text="Golang example"](https://github.com/kontainapp/guide-examples/tree/master/examples/go/golang-http-hello)

+++ Javascript/NodeJS
```shell
docker run -d --rm -p 8080:8080 --runtime=krun --name node-express-hello kontainguide/node-express-hello:1.0
# invoke the service
curl -v http://localhost:8080
# stop the service
docker stop node-express-hello
```

For more details see [Using Kontain with Javascript/NodeJS](/getting_started/javascript)

For impelementation details, you can see:
[!ref target="blank" text="JS/NodeJS example"](https://github.com/kontainapp/guide-examples/tree/master/examples/js/node-express-hello)
+++

## Using examples for more details
You can see the [Kontain guide examples](https://github.com/kontainapp/guide-examples) for more details on how to use Kontain in Kubernetes and docker-compose.

```shell
git clone https://github.com/kontainapp/guide-examples.git
cd examples
````
