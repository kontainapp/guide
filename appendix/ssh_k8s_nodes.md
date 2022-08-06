---
label: SSH into K8s nodes
icon: /images/minikube.png
order: 790
---
## SSH into K8s nodes
To ssh into K8s worker nodes for checking pre-requisites or debugging purposes, you can use the following command:

```
# to ssh into the Kubernetes nodes where you want to test Kontain
# This command starts a privileged container on your node and connects to it over SSH

$ kubectl debug node/<nodeid> -it --image=busybox
or
$ kubectl debug node/<nodeid> -it image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11

# NOTE: After this, you have access to the worker node using a privileged pod launched on the target worker node 
# this mounts the node FS at /host
# so to be able to browse/run commands on the worker node's FS in a normal fashion, you have to do the following:

$ chroot /host
```

For more details:
[!ref text="Install Kontain in Linux"](/getting_started/install_linux)
[!ref text="Kubernetes"](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#node-shell-session)

[!ref text="Azure"](https://docs.microsoft.com/en-us/azure/aks/ssh)

[!ref text="Google Cloud"](https://cloud.google.com/anthos/clusters/docs/on-prem/1.3/how-to/ssh-cluster-node)
