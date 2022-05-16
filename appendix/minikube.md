---
label: Using Kontain in Minikube (with Containerd)
icon: /images/minikube.png
order: 800
---

Minikube is a great little Kubernetes distribution that can be used to verify Kontain working with Vanilla Kubernetes distributions.

### Start Minikube with Containerd as default runtime
For this, Kontain needs a minimum version of Minikube, which can be installed from [here](https://minikube.sigs.k8s.io/docs/start/)

To start Minikube use:
```shell
$ minikube start --container-runtime=containerd --driver=docker --wait=all

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

Now we can use the [instructions here](/guide/getting_started/kubenetes/) to install and use Kontain.

### Clean up
You can remove the Minikube cluster by using the following:

```
$ minikube delete
or 
$ minikube delete -p <profile-name>
```