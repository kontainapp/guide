---
label: Install
icon: gear
order: 1000
---

# Install
### Pre-requisites
Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with virtualization enabled. For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.  Note that this also assumes that your user has access to /dev/kvm.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine is installed.

### Environments
+++ Local (Docker)
##### check for pre-requisites
```shell
$ verify that you have a 64-bit Linux kernel version 4.15 or higher
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

##### install Kontain
```shell
# create the kontain folder for install
$ sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain

# download and install the latest Kontain release
$ curl -s https://raw.githubusercontent.com/kontainapp/km/latest/km-releases/kontain-install.sh | sudo bash

Pulling https://github.com/kontainapp/km/releases/latest/download/kontain.tar.gz...
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

# this installs Kontain in /opt/kontain folder
$ ls -l /opt/kontain
...
drwxr-xr-x 1 smijar  121 296 Nov 10 09:32 bin
drwxr-xr-x 1 smijar  121 140 Nov 10 09:32 lib
drwxr-xr-x 1 smijar  121 194 Nov 10 09:32 runtime
...
```

This installs the necessary files in your /opt/kontain directory and configures the Kontain runtime (/opt/bin/km) for docker or podman. It also executes a smoke test of the unikernel virtual machine.

+++ on Minikube or Managed or Regular Kubernetes
##### Check for pre-requisites on Kubernetes Worker Nodes
You will need to verify pre-requisites on Kubernetes Nodes.  This applies for both Managed Kubernetes and Regular Kubernetes nodes.

```shell
# ssh into the Kubernetes nodes where you want to test Kontain
$ verify that you have a 64-bit Linux kernel version 4.15 or higher
$ uname -m
x86_64

$ uname -r
5.14.14-200.fc34.x86_64

# verify that you have nested virtualization turned on
$ cat /proc/cpuinfo| egrep "vmx|svm" | wc -l
# output must be greater than 0

# verify that you have KVM already installed /dev/kvm enabled by checking:
$ ls -l /dev/kvm
```

##### Install Kontain using Daemonset
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# For Containerd runtime, use the following yaml files:
# install the runtime class
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/runtime-class.yaml
# install configmaps
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/cm-install-lib.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/cm-containerd-install.yaml
# deploy Kontain runtime using kustomize
$ kubectl apply -k https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/base

# To verify the installation, check for kontain-deploy daemonset should appear
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m

```

+++ On a K3s Edge Cluster
##### Check for pre-requisites on Kubernetes Worker Nodes
You will need to verify pre-requisites on Kubernetes Nodes.  This applies for both Managed Kubernetes and Regular Kubernetes nodes.

```shell
# ssh into the Kubernetes nodes where you want to test Kontain
$ verify that you have a 64-bit Linux kernel version 4.15 or higher
$ uname -m
x86_64

$ uname -r
5.14.14-200.fc34.x86_64

# verify that you have nested virtualization turned on
$ cat /proc/cpuinfo| egrep "vmx|svm" | wc -l
# output must be greater than 0

# verify that you have KVM already installed /dev/kvm enabled by checking:
$ ls -l /dev/kvm
```

##### Install Kontain using Daemonset
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# For Containerd runtime, use the following yaml files:
# install the runtime class that uses Kontain as the pod runtime class
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/k3s/cloud/k8s/deploy/runtime-class.yaml
# install configmaps
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/k3s/cloud/k8s/deploy/cm-install-lib.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/k3s/cloud/k8s/deploy/cm-containerd-install.yaml
# deploy Kontain runtime
$ kubectl apply -k https://raw.githubusercontent.com/kontainapp/km/sm/k3s/cloud/k8s/deploy/base

# To verify the installation, check for kontain-deploy daemonset should appear
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m
```
+++