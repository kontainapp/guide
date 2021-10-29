# Quick Start for using Kontain in Kubernetes using Minikube
To checkout how Kontain is deployed and used in Kubernetes, we will use Minikube.  

We will also assume that you have a recent version of Docker pre-installed on your Ubuntu 20 (and above) or Fedora 32 (and above) machines.

You can install Minikube using the instructions [here](https://minikube.sigs.k8s.io/docs/start/).  Note that you will need a recent version of Minikube (Version 1.22.0 or better).

To start Minikube, use:

```bash
# for this example, we will use CRI-O runtime and podman driver, 
#    though we also support Containerd - the default runtime for Minikube
$ minikube start --container-runtime=cri-o --driver=podman

# Check if the kube-system pods have been launched correctly and are in "Running" state:
$ kubectl get pods -n kube-system
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-gqz46            1/1     Running   0          2d21h
kube-system   etcd-minikube                       1/1     Running   0          2d21h
kube-system   kindnet-d7xwr                       1/1     Running   0          2d21h
kube-system   kube-apiserver-minikube             1/1     Running   0          2d21h
...

```


# Deploy Kontain Runtime

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/latest/cloud/k8s/deploy/k8s-deploy.yaml

# To verify the installation
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m

```

A new pod, kontain-deploy should appear.

```bash
$ kubectl get pods -A
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
default       kontain-test-app-647874765d-gnkmv   1/1     Running   0          2d21h
kube-system   coredns-78fcd69978-gqz46            1/1     Running   0          2d21h
kube-system   etcd-minikube                       1/1     Running   0          2d21h
...
kube-system   kontain-deploy-qmtct               1/1     Running   0          17s
...

```