---
label: Using Kontain in Minikube (with Containerd)
icon: /images/minikube.png
order: 800
---

Minikube is a great little Kubernetes distribution that can be used to verify Kontain working with Vanilla Kubernetes distributions.

# Launching a Minikube cluster

## Starting Cluster

### Install Minikube 

Kontain only supports running minikube on linux. To install minikube 

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

If you have another configuration of Linux, refer to [Intallation instructions](https://minikube.sigs.k8s.io/docs/start/)
### Download  Kontain helper script

Download helper script and make sure it is executable

```shell
curl -o minikube-cluster.sh https://raw.githubusercontent.com/kontainapp/k8s-deploy/master/helpers/minikube-cluster.sh
chmod +x minikube-cluster.sh
```
### Start Minikube cluster

#### with Docker and Containerd as runtime

To start Minikube use
```shell
minikube-cluster.sh --driver=docker --runtime=containerd
```
#### with Podman and Containerd as runtime

To start Minikube use
```shell
minikube-cluster.sh --driver=podman --runtime=containerd
```
#### with Podman and CRI-O as runtime

To start Minikube use
```shell
minikube-cluster.sh --driver=podman --runtime=cri-o
```
### Verify your cluster 

```shell
minikube profile list
```

### Check if the kube-system pods have launched properly

```shell
kubectl get pods -n kube-system
```

The result will look like 
:::custom-shell-output
```
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-gqz46            1/1     Running   0          2d21h
kube-system   etcd-minikube                       1/1     Running   0          2d21h
kube-system   kindnet-d7xwr                       1/1     Running   0          2d21h
kube-system   kube-apiserver-minikube             1/1     Running   0          2d21h
```
:::

## Enable and Test Kontain Runtime
Please refer to: [Install Kontain in Kubernetes](/getting_started/kubenetes/)

### Clean up
To delete cluster and all associated resources use the following
```
minikube-cluster.sh --cleanup
```