---
label: Minikube CRI-O
icon: /images/minikube.png
order: 800
---

## Using Kontain in Minikube with CRI-O
Minikube is a great little Kubernetes distribution that can be used to verify Kontain working with Vanilla Kubernetes distributions.  Usually, Minikube comes with VirtualBox in order to create the relevant Kubernetes Master and Worker nodes.  But, Minikube can also launch in Docker in Docker (DIND) mode, where it launches quickly in Docker, where the Master and Worker nodes are plain Docker containers.

### Minikube cluster with CRI-O
For this, Kontain needs a minimum version of Minikube, which can be installed from [here](https://minikube.sigs.k8s.io/docs/start/)

To start Minikube use:
```shell
$ minikube start --container-runtime=cri-o --driver=podman --wait=all

# to see status of cluster (s) - cluster name is 'default'
$ minikube profile list
|----------|-----------|------------|--------------|------|---------|---------|-------|
| Profile  | VM Driver |  Runtime   |      IP      | Port | Version | Status  | Nodes |
|----------|-----------|------------|--------------|------|---------|---------|-------|
| default  | docker    | containerd | 192.168.58.2 | 8443 | v1.22.2 | Running |     1 |
|----------|-----------|------------|--------------|------|---------|---------|-------|

# check if the kube-system pods have launched properly
$ kubectl get pods -n kube-system
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-gqz46            1/1     Running   0          2d21h
kube-system   etcd-minikube                       1/1     Running   0          2d21h
kube-system   kindnet-d7xwr                       1/1     Running   0          2d21h
kube-system   kube-apiserver-minikube             1/1     Running   0          2d21h
```

### Using Kontain with CRI-O Minikube
Now we can use the [instructions here](/guide/getting_started/kubenetes/) to install and use Kontain.

### Clean up
You can remove the Minikube cluster by using the following:

```shell
$ minikube delete
or 
$ minikube delete -p <default>
```
