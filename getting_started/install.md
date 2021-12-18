---
label: Install (in Docker, in K8s)
icon: /images/docker-kube.png
order: 1000
---

# Install
### Pre-requisites
Kontain runs on Linux kernel version 4.15 or newer, running on Intel VT (vmx) or AMD (svm) with virtualization enabled. For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

Recommended distros are Ubuntu 20.04 and Fedora 32, or newer.  Note that this also assumes that your user has access to /dev/kvm.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine is installed.

### Environments
+++ Local (Docker)
#### Optional: Installing Docker in Fedora/RHEL systems
If not present, you can install Docker On Fedora/RHEL systems using [instructions from here](https://developer.fedoraproject.org/tools/docker/docker-installation.html)

##### check for pre-requisites
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


+++ in Minikube or Managed or Regular Kubernetes
#### Optional: Appendix contains instructions for launching various versions of Kubernetes
As a convenience, we have provided convenient for installing or running various versions of Kubernetes for testing Kontain.

For example, on a **desktop version of Kubernetes**, you can use Minikube with Docker Desktop [view instructions here](/appendix/minikube/).

For launching a **managed cluster in Azure AKS**, the instrutions are [here](/appendix/azure_aks.md)

For simulating an **edge cluster with k3s using Vagrant**, the instrutions are [here](/appendix/k3s.md)

#### Check for pre-requisites on Kubernetes Worker Nodes
You will need to verify pre-requisites on Kubernetes Nodes.  This applies for both Managed Kubernetes and Regular Kubernetes nodes.

```shell
# get the list of nodes
$ kubectl get nodes -o wide

# to ssh into the Kubernetes nodes where you want to test or install Kontain
# This command starts a privileged container on your node and connects to it over SSH
$ kubectl debug node/<nodeid> --image=busybox
or
$ kubectl debug node<nodeid> image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11


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
```

#### Install Kontain using Daemonset 
##### if using Containerd (default runtime for almost all Kubernetes installations)
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# For Containerd runtime, use the following install script
$ curl https://raw.githubusercontent.com/kontainapp/guide/main/_scripts/kontain_k8s_install.sh | sh
```

##### If using CRIO (runtime)
```shell
# If using CRIO as the runtime, use the following install script
$ curl https://raw.githubusercontent.com/kontainapp/guide/main/_scripts/kontain_k8s_crio_install.sh | sh
```

+++ On a K3s Edge Cluster
#### Check for pre-requisites on Kubernetes Worker Nodes
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

#### Install Kontain using Daemonset
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# For installing Kontain on a k3s cluster, use the following install script
$ curl https://raw.githubusercontent.com/kontainapp/guide/main/_scripts/kontain_k3s_install.sh | sh

```

+++ Verify Install
#### Verify that Kontain has been deployed successfully
```shell
# verify that the kontain-node-initializer ran successfully and is in "Running" state and not "Error" state
$ kubectl get po -n kube-system
kube-system   azure-ip-masq-agent-tr7c7             1/1     Running   0          37m
kube-system   coredns-58567c6d46-ncsqq              1/1     Running   0          38m
kube-system   coredns-58567c6d46-rrb4m              1/1     Running   0          36m
kube-system   coredns-autoscaler-54d55c8b75-j97sj   1/1     Running   0          38m
kube-system   kontain-node-initializer-tvr84        1/1     Running   0          39s
kube-system   kube-proxy-7hkjc                      1/1     Running   0          37m
kube-system   metrics-server-569f6547dd-flsb4       1/1     Running   1          38m
kube-system   tunnelfront-7d8df6bfdc-dr6z2          1/1     Running   0          38m

# to debug an "Error" state, you can view its logs:
$ kubectl logs kontain-node-initializer-<id>
...

# check the daemonset
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m

```

#### Run a Kontain test app to verify that the runtime class is working as designed
```shell
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/latest/demo/k8s/test.yaml

# a new Kontain test app should appear as 'Running'

$ kubectl get pods 
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
default       kontain-test-app-647874765d-7ftrp   1/1     Running   0          23m

# Use kubectl exec to run uname -r on the test pod. When running under the Kontain Runtime, the uname(2) system call appends the string "kontain." to the release name. 
# (Note: Please replace the kontain-test-app-xxxxx with the appropriate pod id).

$ kubectl exec -it kontain-test-<appropriate-pod-id>  -- uname -r
5.13.7-100.fc33.x86_64.kontain.KVM
```

+++