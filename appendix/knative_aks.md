---
label: Installing KNative with Kontain on Azure AKS
icon: /images/aks.png
order: 880
---
# KNative and Kontain on AKS Cluster
### Installing client-side knative CLI
To view and query knative services in Kubernetes, you need the knative CLI.  You can install this on your own desktop OS as shown below.

```shell
$ sudo curl -s -Lo /usr/local/bin/kn https://github.com/knative/client/releases/download/knative-v1.4.1/kn-linux-amd64
$ sudo chmod +x /usr/local/bin/kn
```

### Install Kontain on AKS Cluster
Once you have [started your AKS Kubernetes Cluster](/appendix/azure_aks), you can install Kontain as shown below:

```shell
# install Kontain using daemonset install
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/infra/kustomize_outputs/km.yaml

# verify that daemonset is running
$ kubectl get po -n kube-system
kube-system   azure-ip-masq-agent-tr7c7             1/1     Running   0          37m
kube-system   coredns-58567c6d46-ncsqq              1/1     Running   0          38m
kube-system   coredns-58567c6d46-rrb4m              1/1     Running   0          36m
kube-system   coredns-autoscaler-54d55c8b75-j97sj   1/1     Running   0          38m
kube-system   kontain-node-initializer-tvr84        1/1     Running   0          39s
kube-system   kube-proxy-7hkjc                      1/1     Running   0          37m
kube-system   metrics-server-569f6547dd-flsb4       1/1     Running   1          38m
kube-system   tunnelfront-7d8df6bfdc-dr6z2          1/1     Running   0          38m

# to check logs of the daemonset use
$ kubectl logs -n kube-system daemonset/kontain-node-initializer
```

### Install KNative on AKS Cluster
Below we show the steps needed to install KNative on AKS cluster.  We follow the instructions from the [knative docs](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/#prerequisites).

```shell
# 1. Install the required custom resources by running the command:
echo "install knative serving component crds"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-crds.yaml

# 2. Install the core components of Knative Serving by running the command:
echo "install knative serving core components"
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-core.yaml

# networking kourier
# 3. Install the Knative Kourier controller by running the command:
echo "installing kourier controller"
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.4.0/kourier.yaml

# 4. Configure Knative Serving to use Kourier by default by running the command:
echo "configuring knative serving to use Kourier by default"
kubectl patch configmap/config-network \
                --namespace knative-serving \
                --type merge \
                --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

# 5. patch configuration so that runtime class is "enabled" because its disabled by default
echo "patching config to enable use of runtime class"
kubectl patch configmap/config-features \
    -n knative-serving \
    --type merge \
    -p '{"data":{"kubernetes.podspec-runtimeclassname": "enabled"}}'

# 6. Fetch the External IP address or CNAME by running the command:
echo "getting external IP or CNAME"
kubectl --namespace kourier-system get service kourier

# 7. Configure DNS to use Magic DNS (sslip.io) so as not use to curl with Host header
# Knative provides a Kubernetes Job called default-domain that configures Knative Serving to use sslip.io as the default DNS suffix.
echo configuring k8s default-domain job to use magic DNS - sslip.io
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.4.0/serving-default-domain.yaml

# 8. verify the install
echo verifying the install
kubectl get pods -n knative-serving
```

### Testing the install
Below we will use Kontain and knative to test a python flask hello service.

```shell
# view the knative service manifest
$ curl https://raw.githubusercontent.com/kontainapp/guide-examples/master/examples/knative/basics/py-flask-hello.yml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: py-flask-hello
spec:
  template:
    spec:
      runtimeClassName: kontain
      containers:
        - image: kontainguide/py-flask-hello:1.0
          ports:
            - containerPort: 5000

# create a Kontain-based Python flask hello service on port 8080
$ kubectl apply -f https://raw.githubusercontent.com/kontainapp/guide-examples/master/examples/knative/basics/py-flask-hello.yml

# list the service running
$ kn service list
kn service list
NAME                    URL                                                          LATEST                        AGE   CONDITIONS   READY   REASON
py-flask-hello          http://py-flask-hello.default.52.143.74.16.sslip.io          py-flask-hello-00001          15s   3 OK / 3     True

# test it
$ curl http://py-flask-hello.default.52.143.74.16.sslip.io
Hello from Kontain!
```

### Kubernetes events
Kubernetes events provide a very good insight into how Kubernetes makes a knative service ready.  Its a great way to debug services.  

Here is a [great reference](https://www.containiq.com/post/kubernetes-events) to Kubernetes events and viewing them.

```shell
# viewing kubernetes events
$ kubectl get events
...
...
6m3s        Normal    Created                 pod/py-flask-hello-00001-deployment-674697d47f-57g4g           Created container queue-proxy
6m3s        Normal    Started                 pod/py-flask-hello-00001-deployment-674697d47f-57g4g           Started container queue-proxy
5m54s       Normal    RevisionReady           revision/py-flask-hello-00001                                  Revision becomes ready upon all resources being ready
6m5s        Normal    Created                 service/py-flask-hello                                         Created Configuration "py-flask-hello"
6m5s        Normal    Created                 configuration/py-flask-hello                                   Created Revision "py-flask-hello-00001"
6m5s        Normal    Created                 service/py-flask-hello                                         Created Route "py-flask-hello"
6m5s        Normal    FinalizerUpdate         route/py-flask-hello                                           Updated "py-flask-hello" finalizers
5m54s       Normal    ConfigurationReady      configuration/py-flask-hello                                   Configuration becomes ready
5m54s       Normal    LatestReadyUpdate       configuration/py-flask-hello                                   LatestReadyRevisionName updated to "py-flask-hello-00001"
5m54s       Normal    Created                 route/py-flask-hello                                           Created placeholder service "py-flask-hello"
5m54s       Normal    Created                 route/py-flask-hello                                           Created Ingress "py-flask-hello"
5m54s       Normal    FinalizerUpdate         ingress/py-flask-hello                                         Updated "py-flask-hello" finalizers
.....
...
