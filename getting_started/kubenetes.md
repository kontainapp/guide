---
label: Install in Kubernetes (Minikube/Kind, AWS, AKS, GKE)
icon: /images/k8s.png
order: 995
---

# Installing in Kubernetes
## Pre-requisites for Kubernetes Worker node to run Kontain
Kontain runs on *Linux kernel version 4.15 or newer*, running on Intel VT (vmx) or AMD (svm) with KVM based virtualization enabled, ideally Ubuntu or Fedora.  

To check for pre-requisites on Kubernetes worker nodes, you can refer to [this link](/getting_started/install_linux/#checking-for-pre-requisites)

For more information to enable KVM on Ubuntu 20.04 or higher, you can refer to this [article](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-20-04/).

For Kubernetes platforms that do not offer nested virtualization like GKE and AWS, we use a software virtualization module that gets installed as part of the Kontain install.  For other platforms that do offer nested virtualization, we recommend using the regular Kontain install.

Recommended distros for Kubernetes Worker Nodes are Ubuntu 20.04 and Amazon Linux 2, or newer.

To package Kontain images, it is also necessary to have a recent version of Docker or Moby-engine is installed.

==- Tip: Starting a Kubernetes cluster with Minikube or kind
contains instructions for launching various versions of Kubernetes
For trying out Kontain with Kubernetes, you can launch Minikube with Docker Desktop [view instructions here](/appendix/minikube/).

```shell
 kind create cluster
```

or Minikube:

```shell
 minikube start --container-runtime=containerd --driver=docker --wait=all
```
===


## Enabling Kontain on Cloud Kubernetes/Openshift
+++ Azure AKS
Deploy Kontain Runtime using the Kubernetes client CLI and Kontain Deamonset

```shell
 kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/current/cloud/k8s/deploy/azure-aks/kontain-install.yaml
```

The above yaml contains the Kontain runtime class and the install scripts for the Daemonset to be installed.

+++ AWS EKS
To create EKS cluster with Kontain:

1. Create cluster on EKS using Kontain-enabled AMI (kontain-eks-node-1.22-*version*)
    You can use Amazon AWS Management Console or eksctl as described in ["Getting started with Amazon EKS"](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html).
    Alternatively, you can download Kontain EKS cluster creation script create-cluster.sh and run as shown below or customize it as needed
    
    !!!
    Note: AWS CLI is required by eksclt and create-cluster.sh
    !!!

    To run script:

    ```console
     curl -o create-cluster.sh https://raw.githubusercontent.com/kontainapp/km/current/cloud/k8s/deploy/amazon-eks/create-cluster.sh
     chmod +x create-cluster.sh 
     ./create-cluster.sh --region=<your region> --ami=<Kontain-enabled AMI ID> <prefix>
    ```
    where \<prefix\> is used as your unique cluster identifier and is pre-pended to all resource names related to your cluster

2. Create Kontain RuntimeClass resources

    ```console
     kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/current/cloud/k8s/deploy/amazon-eks/kontain-runtime-config.yaml

+++ Google Cloud GKE
To install Kontain on GKE use:

```shell
 kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/kkm.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++ K3s
To install Kontain on K3s:

```shell
 kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++ Openshift with CRIO
To install Kontain on Openshift or Minikube with CRIO:

```shell
 kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km-crio.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++ Other 
Install Kontain using Deamonset 

```shell
# we install Kontain using a Daemonset
 kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++

## Verify Install
Let's run a Kontain test app to verify that the runtime class is working as designed

```shell
kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/current/cloud/k8s/tools/test.yaml
```
a new Kontain test app should appear as 'Running'

```shell
kubectl get pods 
```
The example output is as follows.

:::custom-shell-output
```
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
default       kontain-test-app-647874765d-7ftrp   1/1     Running   0          23m
```
:::

Use kubectl exec to run uname -r on the test pod. When running under the Kontain Runtime, the uname(2) system call appends the string "kontain." to the release name. 


!!!
Note: Please replace the kontain-test-app-xxxxx with the appropriate pod id.
!!!


```shell
kubectl exec -it kontain-test-<appropriate-pod-id>  -- uname -r 
```

The output example is 
:::custom-shell-output
```
<kernel-version>.<host-name>.x86_64.kontain.KVM or <kernel-version>.<host-name>.x86_64.kontain.KKM
```
:::

To verify that Kontain Daemonset has been successfull and the kontain-node-initializer ran successfully and is in "Running" state and not "Error" state
```shell
 kubectl get po -n kube-system
```

You will see output similar to
:::custom-shell-output
```
kube-system   azure-ip-masq-agent-tr7c7             1/1     Running   0          37m
kube-system   coredns-58567c6d46-ncsqq              1/1     Running   0          38m
kube-system   coredns-58567c6d46-rrb4m              1/1     Running   0          36m
kube-system   coredns-autoscaler-54d55c8b75-j97sj   1/1     Running   0          38m
kube-system   kontain-node-initializer-tvr84        1/1     Running   0          39s
kube-system   kube-proxy-7hkjc                      1/1     Running   0          37m
kube-system   metrics-server-569f6547dd-flsb4       1/1     Running   1          38m
kube-system   tunnelfront-7d8df6bfdc-dr6z2          1/1     Running   0          38m
```
:::

If need be, to debug an "Error" state, you can view its logs:
```shell
 kubectl logs kontain-node-initializer-<id>
```

To check the daemonset status
```shell
 kubectl get daemonsets.apps -A
```
The output will be similar to the following

:::custom-shell-output
```
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m
```
:::

### Using Kontain to deploy Java, Python, Golang and JS examples in Kubernetes
[!ref text="examples" target=_blank](https://github.com/kontainapp/guide-examples/tree/master/examples)

