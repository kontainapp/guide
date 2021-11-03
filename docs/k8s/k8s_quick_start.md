# Quick Start for using Kontain in Kubernetes using Minikube
To checkout how Kontain is deployed and used in Kubernetes, we will use Minikube.  

We will also assume that you have a recent version of Docker pre-installed on your Ubuntu 20 (and above) or Fedora 32 (and above) machines.

You can install Minikube using the instructions [here](https://minikube.sigs.k8s.io/docs/start/).  Note that you will need a recent version of Minikube (Version 1.22.0 or better).

### Start a Minikube cluster "kontain"
```bash
# if you want to delete your "default" minikube cluster
$ minikube delete

# OR start a new separate cluster named "kontain" with CRI-O runtime and podman as the container driver
$ minikube start -p kontain --container-runtime=cri-o --driver=podman
...
Done! kubectl is now configured to use "kontain" cluster and "default" namespace by default

# to see status of clusters
$ minikube profile list
...


# Check if the kube-system pods have been launched correctly and are in "Running" state:
$ kubectl get pods -n kube-system
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-78fcd69978-gqz46            1/1     Running   0          2d21h
kube-system   etcd-minikube                       1/1     Running   0          2d21h
kube-system   kindnet-d7xwr                       1/1     Running   0          2d21h
kube-system   kube-apiserver-minikube             1/1     Running   0          2d21h
...

```

### Deploy Kontain runtime in Minikube
Now, to install Kontain runtime in Minikube, we will need to use a Daemonset.  This installs Kontain on all the nodes of the Kubernetes cluster.
```bash

# Deploy Kontain Runtime

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/latest/cloud/k8s/deploy/k8s-deploy.yaml

# To verify the installation, kontain-deploy should appear.
$ kubectl get daemonsets.apps -A
NAMESPACE     NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   kindnet          1         1         1       1            1           <none>                   168m
kube-system   kontain-deploy   1         1         1       1            1           <none>                   163m
kube-system   kube-proxy       1         1         1       1            1           kubernetes.io/os=linux   168m

```

### Verify
Run a test app to verify Kontain running in Kubernetes.

```bash
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/latest/demo/k8s/test.yaml

# A new pod, kontain-test-app-xxxxx should appear.
$ kubectl get pods -n default
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
default       kontain-test-app-647874765d-7ftrp   1/1     Running   0          23m

# Check that the pod runs with the Kontain runtime
$ kubectl exec -it kontain-test-app-647874765d-7ftrp  -- uname -r
5.13.7-100.fc33.x86_64.kontain.KVM
```

Tip: To load images built in the local docker registry to minikube, you can use: $ docker save <image_name:tag> | (eval $(minikube podman-env) && podman load)