---
label: Install in Kubernetes (Minikube/Kind, AWS, AKS, GKE)
icon: /images/k8s.png
order: 995
---

# Installing in Kubernetes
## Pre-requisites
Kontain runs on *Linux kernel version 4.15 or newer*, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally Ubuntu or Fedora.  For enabling KVM on Ubuntu 18.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-18-04/).

For Kubernetes platforms that do not offer nested virtualization like GKE and AWS, we use a software virtualization module that gets installed as part of the Kontain install.  For other platforms that do offer nested virtualization, we recommend using the regular Kontain install.

Recommended distros for Kubernetes Worker Nodes are Ubuntu 20.04 and Amazon Linux 2, or newer.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine is installed.

==- Tip: starting a Kubernetes cluster with Minikube or kind
contains instructions for launching various versions of Kubernetes
For trying out Kontain with Kubernetes, you can launch Minikube with Docker Desktop [view instructions here](/appendix/minikube/).

```shell
$ kind create cluster
```

or Minikube:

```shell
$ minikube start --container-runtime=containerd --driver=docker --wait=all
```
===

## Install Kontain using Daemonset 
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# we install Kontain using a Daemonset
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

The above yaml contains the Kontain runtime class and the install scripts for the Daemonset to be installed.

## Verify Install
Let's run a Kontain test app to verify that the runtime class is working as designed

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

If you wish to view the Kontain Daemonset:
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

# if need be, to debug an "Error" state, you can view its logs:
$ kubectl logs kontain-node-initializer-<id>

# check the daemonset
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m
```

## Installing in other Kubernetes
+++ Azure AKS
Deploy Kontain Runtime using the Kubernetes client CLI

```shell
# we install Kontain using a Daemonset
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

The above yaml contains the Kontain runtime class and the install scripts for the Daemonset to be installed.

+++ AWS EKS (with Containerd) and Google Cloud GKE
To install Kontain on AWS (with containerd) or GKE use:

```shell
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

As Docker shim is being deprecated in AWS EKS, please note that to use Kontain on AWS EKS, you will need to launch the cluster using containerd as the default runtime.  Please see: [Docker shim deprecation](https://docs.aws.amazon.com/eks/latest/userguide/dockershim-deprecation.html)

 To enable containerd as default rutime, please see: [Enabling Containerd in EKS](https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html#containerd-bootstrap)

+++ K3s
To install Kontain on K3s:

```shell
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++ Openshift with CRIO
To install Kontain on Openshift or Minikube with CRIO:

```shell
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km-crio.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++

## Using Kontain to deploy Java, Python, Golang and JS examples in Kubernetes
[!ref text="examples" target=_blank](https://github.com/kontainapp/guide-examples/tree/master/examples)