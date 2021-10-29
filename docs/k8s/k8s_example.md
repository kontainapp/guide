# Microservice Example
Now we take a python Flask example that we worked on in the [previous](/gettingstarted/python_flask) Docker example and deploy it to Kubernetes.  We assume that the image is available at Docker Hub.

The K8s deployment yaml (flaskapp.yml) along with the service at port 5000 is shown below:
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: flaskapp
  labels:
    app: flaskapp
spec:
  type: ClusterIP 
  ports:
  - port: 5000
    targetPort: 5000
    protocol: TCP
  selector:
    app: flaskapp
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flaskapp
  labels:
    app: flaskapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flaskapp
  template:
    metadata:
      labels:
        app: flaskapp
    spec:
      runtimeClassName: kontain
      containers:
      - name: flaskapp
        image: sandman2k/pyflask:1.0
        ports:
        - containerPort: 5000
```

We deploy this using:
```bash
$ kubectl deploy flaskapp.yml

# verify that the pod is running
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
flaskapp-955645cf8-mfrtj            1/1     Running   0          15m
```

Now we port forward the service's port to local port to test out that the service is running:
```bash
$ kubectl port-forward po/flaskapp-955645cf8-mfrtj 5000:5000

# please note that this is a blocking operation
```

In another terminal window we test using curl to verify the output from the service:
```bash
$ curl http://localhost:5000
Hello from Kontain!
```

Above we see the output from our Python app wrapped in a Kontain based image.
