# Microservice Example
Now we take a python Flask example that we worked on in the [previous](/gettingstarted/java) Docker example and deploy it to Kubernetes.  We assume that the image is available at Docker Hub.

The K8s deployment yaml (springbootapp_k8s.yml) along with the service at port 8080 is shown below:
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: springbootapp
  labels:
    app: springbootapp
spec:
  type: ClusterIP 
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: springbootapp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: springbootapp
  labels:
    app: springbootapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springbootapp
  template:
    metadata:
      labels:
        app: springbootapp
    spec:
      runtimeClassName: kontain
      containers:
      - name: springbootapp
        image: sandman2k/springboothello:1.0
        ports:
        - containerPort: 8080
```

We deploy this using:
```bash
$ kubectl apply -f springbootapp_k8s.yml

# verify that the pod is running
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
springbootapp-955645cf8-mfrtj            1/1     Running   0          15m
```

Now we port forward the service's port to local port to test out that the service is running:
```bash
$ kubectl port-forward po/springbootapp-955645cf8-mfrtj 8080:8080

# please note that you have to keep this terminal window open before the next step
```

In another terminal window we test using curl to verify the output from the service:
```bash
$ curl http://localhost:8080
Hello from Kontain!
```

Above we see the output from our Sprint Boot app wrapped in a Kontain based image.


To clean up:
```bash
$ kubectl delete -f flaskapp_k8s
```