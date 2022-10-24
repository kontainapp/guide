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

For Kubernetes platforms that do not offer nested virtualization like GKE and AWS, we use a software virtualization module that gets installed as part of the Kontain install.

Recommended distros for Kubernetes Worker Nodes are Ubuntu 20.04 and Amazon Linux 2, or newer. For Amazon EKS Kontain maintains kontain-compatible AMI which is a derivitive of Amazon Linux 2 and can be found by filter "kontain-eks-node*". For GKE make sure to use UBUNTU_CONTAINERD image type. 

==- Tip: Creating Kubernetes Cluster
Kontain provides the following shell helper scripts that you can use to create and start cluster for a number of different cluster environments:

- [Azure AKS Cluster](/appendix/azure_aks/)
- [Amazon EKS](/appendix/amazon_eks/)
- [Google GKE](/appendix/google-gke/)
- [K3S](/appendix/k3s/)
- [Minikube](/appendix/minikube/)

===


## Enabling Kontain Runtime on Kubernetes Cluster

+++ AKS, EKS, GKE, K3S, and Minikube clusters

To enable Kontain runtime 
```
curl -s https://raw.githubusercontent.com/kontainapp/k8s-deploy/current/kontain-kustomize.sh | bash -s - [options]
```
### Script options

kontain-kustomize.sh [--deploy-version=version | --deploy-location=path] [--km-version=version | --km-url=url>] [--dry-run=strategy] [--download=path] [--remove]

Option| Usage { class="options-table" }
----------------------------------|---
--deploy-version=\<tag> | Kontain deployment version to use. Defaults to current release
--deploy-location=\<deployment location> | location of local kontain-deploy directory. Use --download to download kontain-deploy directory to local path 
--km-version=\<tag> | Kontain release to deploy. Defaults to current Kontain release
--km-url=\<url> | url to download kontain_bin.tar.gz. Development only
--help(-h) | prints this message
--dry-run=\<strategy> | if 'review' strategy, only generate resulting customization file. If 'client' strategy, only print the object that would be sent, without sending it. If 'server' strategy, submit server-side request without persisting the resource
--download=\<path> | downloads kontain-deploy directory structure to specified location. If directory down not exist, it will be created. This directory can be used as path for --deploy-location 
 --remove | removes all the resources produced by overlay

+++ Other 
To install Kontain using Deamonset, first generate deployment file:  

```shell
curl -s https://raw.githubusercontent.com/kontainapp/k8s-deploy/current/kontain-kustomize.sh | bash -s - --dry-run=review
```

This command will create kontain-deploy.yaml file in local directory. 
You can now apply it to your Kubernetes installation using the following command

```shell
kubectl apply -f kontain-deploy.yaml
```

The above installs the Kontain runtime class and contains the libraries for installing Kontain using the daemonset.

+++

## Verify Install
Let's run a Kontain test app to verify that the runtime class is working as designed

```shell
kubectl apply -f https://raw.githubusercontent.com/kontainapp/k8s-deploy/current/tests/test.yaml
```
A new Kontain test app should appear as 'Running'. You can check that by running the following command

```shell
kubectl get pods 
```
The example output is as follows

:::custom-shell-output
```
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
default       kontain-test-app-647874765d-7ftrp   1/1     Running   0          2m
```
:::

Use kubectl exec to run uname -r on the test pod.


```shell
kubectl exec deployment.apps/kontain-test-app -- uname -r
```
When running under the Kontain Runtime, the uname(2) system call adds the string "kontain" to the release name 

:::custom-shell-output
```
<kernel-version>.<host-name>.x86_64.kontain.KVM 
```
:::
or
:::custom-shell-output
```
<kernel-version>.<host-name>.x86_64.kontain.KKM
```
:::


To verify that Kontain Daemonset has been successfull and the kontain-node-initializer ran successfully and is in "Running" state and not "Error" state
```shell
kubectl get pods -n kube-system -l app=kontain-init
```

You will see output similar to
:::custom-shell-output
```
kube-system   kontain-node-initializer-tvr84        1/1     Running   0          3m
```
:::

If need be, to debug an "Error" state, you can view its logs
```shell
kubectl logs -n kube-system kontain-node-initializer-<id>
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
## Modifying your Deployment to run with Kontain Runtime
To run your deployment using Kontain runtime modify deployment file by adding runtimeClass and nodeSelector as highlighted below in out test deployment

```yaml !#14-16
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kontain-test-app
spec:
  selector:
    matchLabels:
      kontain: test-app
  template:
    metadata:
      labels:
        kontain: test-app
    spec:
      runtimeClassName: kontain
      nodeSelector:
        sandbox: kontain
      containers:
        - name: kontain-test-app
          image: busybox:latest
          command: ["sleep", "infinity"]
          imagePullPolicy: IfNotPresent
```
## Using Kontain to deploy Java, Python, Golang and JS examples in Kubernetes
[!ref text="examples" target=_blank](https://github.com/kontainapp/guide-examples/tree/master/examples)

