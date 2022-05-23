---
label: knative (serverless)
icon: /images/java.png
order: 595
---

[!ref text="knative examples" target=_blank](https://github.com/kontainapp/guide-examples/tree/master/examples/knative/basics)

This section shows how we can use Kontain in a serverless or funtions as a service environment to secure Functions using hardware virtualization based workload isolation.

We can use the same guide-examples gihub repo to see the files associated with this example as linked to above.

## Description
This describes how to use Kontain with KNative.  It shows you how to:
- install KNative in a kind cluster 
- and install Kontain
- deploy and run a KNative service that uses a secure Kontain Container to run the function


## Starting a knative kind cluster with Kontain
### Installing knative kind quickstart plugins on your local desktop
Note that this has to be done **only once**.  
Also, please note that this has to be done on an OS that satisfies the pre-requisites for Kontain as shown earlier.

```shell
$ make knativecluster-plugins-install
```

### Starting the kind cluster with knative and kontain installed
```shell
$ make knativekindcluster-up
```


## Working with KNative Kontain-enabled services
### Deploy the service

The service manifest file:
[hello-kontain-svc.yml](https://github.com/kontainapp/guide-examples/blob/master/examples/knative/basics/hello-kontain-svc.yml)
```shell
# install the Kontain-enabled function as a service
$ kubectl apply -f hello-kontain-svc.yml 

# check the service
$ kn service list
NAME            URL                                               LATEST                AGE   CONDITIONS   READY   REASON
hello-kontain   http://hello-kontain.default.127.0.0.1.sslip.io   hello-kontain-00001   27s   3 OK / 3     True
```


### Invoke the service

```shell
$ curl $(kn service describe hello-kontain -o url)
Hello World!
```


### Deploy an update to the service with a revision

The revised service manifest file:

[hello-kontain-svc-revised.yml](https://github.com/kontainapp/guide-examples/blob/master/examples/knative/basics/hello-kontain-svc-revised.yml)
```shell
$ kubectl apply -f hello-kontain-svc-revised.yml

$ curl $(kn service describe hello-kontain -o url)
Hello knative!
```


### Check for traffic being routed to current revision

```shell
$ kn revisions list
NAME                  SERVICE         TRAFFIC   TAGS   GENERATION   AGE     CONDITIONS   READY   REASON
hello-kontain-00002   hello-kontain   100%             2            5m16s   3 OK / 4     True    
hello-kontain-00001   hello-kontain                    1            34m     3 OK / 4     True
```


### Canary service deployment: 50% to revision
The service manifest wwith the traffic split direct for revisions:

[hello-kontain-svc-traffic-split.yml](https://github.com/kontainapp/guide-examples/blob/master/examples/knative/basics/hello-kontain-svc-traffic-split.yml)
```shell
$ kubectl apply -f hello-kontain-svc-traffic-split.yml

# check the traffic split
$ kn revisions list
NAME                  SERVICE         TRAFFIC   TAGS   GENERATION   AGE   CONDITIONS   READY   REASON
hello-kontain-00002   hello-kontain   50%              2            20m   4 OK / 4     True    
hello-kontain-00001   hello-kontain   50%              1            49m   4 OK / 4     True

$ echo checking the traffic split implementation by invoking service 20 times...
$ for i in {1..20}; do curl $(kn service describe hello-kontain -o url); done76s
Hello World!
Hello Kontain!
Hello World!
Hello Kontain!
...
...
```

## Working with KNative Kontain-enabled Spring Boot service
### From scale to zero state to starting up to respond to a request
At first, we will show the regular spring boot knative service running, and replying to a request from scale to zero state.

```shell
# deploy the knative spring boot hello service
$ kubectl apply -f springboothello-kontain.yml

# watch it getting deployed
$ kubectl get po -w

# see list of kontain-enabled services
$ kn service list
NAME                             URL                                                                LATEST                                 AGE     CONDITIONS   READY   REASON
hello-kontain                    http://hello-kontain.default.127.0.0.1.sslip.io                    hello-kontain-00001                    42m     3 OK / 3     True
hello-kontain-spring-boot        http://hello-kontain-spring-boot.default.127.0.0.1.sslip.io        hello-kontain-spring-boot-00001        19m     3 OK / 3     True

# sleep for a few seconds for the pod to be terminated to test scale to zero and up
$ sleep 10

# invoke the spring boot service
$ curl $(kn service describe hello-kontain-spring-boot -o url)
Hello from Kontain!

# Note that it takes about 8 seconds for it to respond
```

### From scale to zero state to response, using a Snapshot of the Spring Boot service
Now, we will show the same spring boot knative service in scale to zero state, and then starting up to reply to a request from scale to zero state.
```shell
# deploy the knative spring boot hello service
$ kubectl apply -f springboothello-kontain-snap.yml

# watch it getting deployed
$ kubectl get po -w

# see list of kontain-enabled services
$ kn service list
NAME                             URL                                                                LATEST                                 AGE     CONDITIONS   READY   REASON
hello-kontain                    http://hello-kontain.default.127.0.0.1.sslip.io                    hello-kontain-00001                    42m     3 OK / 3     True
hello-kontain-spring-boot        http://hello-kontain-spring-boot.default.127.0.0.1.sslip.io        hello-kontain-spring-boot-00001        19m     3 OK / 3     True
hello-kontain-spring-boot-snap   http://hello-kontain-spring-boot-snap.default.127.0.0.1.sslip.io   hello-kontain-spring-boot-snap-00001   9m53s   3 OK / 3     True

# sleep for a few seconds for the pod to be terminated to test scale to zero and up
$ sleep 10

# invoke the spring boot service
$ curl $(kn service describe hello-kontain-spring-boot-snap -o url)
Hello from Kontain!

# Note that it takes only about 3 seconds for it to respond
# - most of it is spent in starting up the container, for Kubernetes to get its liveness and readiness probe ready etc.
```
