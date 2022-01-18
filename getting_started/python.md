---
label: Python Flask (Docker/K8s)
icon: /images/python.png
order: 900
---

Below is a short example of bundling a python microservice in a Kontain-based Container with Docker:

## files

### tree
```
├── app
│   ├── __init__.py
│   └── main.py
├── Dockerfile
└── requirements.txt
```

### python application app/main.py

```python
from flask import Flask
app = Flask(__name__)
 
@app.route("/")
def hello():
    return "Hello from Kontain!"
 
if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

### requirements.txt
```
$ cat requirements.txt
flask

$ touch app/__init__.py
```


## Docker
### Dockerfile

```docker
FROM python:3.8-slim AS build
WORKDIR /opt/src/app

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
 
ADD . /opt/src/
RUN pip install -r /opt/src/requirements.txt
 
ADD app/main.py /opt/src/app/
#RUN find /opt/src/


FROM kontainapp/runenv-python-3.8:v0.9.1 as release
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/src/app /opt/src/app
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/src/app
 
EXPOSE 5000
# CMD ["python", "main.py"]
CMD . /opt/venv/bin/activate && exec python main.py
```

### Build the Kontain Container image

```sh
$ docker build -t kg/pyflask .
```

### Run using Docker

```sh
$ docker run --rm  --runtime=krun -p 5000:5000 kg/pyflask
$ curl http://localhost:5000/
Hello from Kontain!
```

### Check Kontain Container image size
```sh
$ docker images|grep "3.8-slim"
python       3.8-slim                 d30b976a9197   2 months ago    122MB

$ docker images | grep "kg/pyflask"
kg/pyflask   latest                   3c038d3aebef   2 hours ago     **40.2MB**
```

### Check for vulnerabilities
```sh
# first, check the base python image
$ grype python:3.8-slim|wc -l
 ✔ Vulnerability DB        [no update available]
 ✔ Loaded image
 ✔ Parsed image
 ✔ Cataloged packages      [108 packages]
 ✔ Scanned image           [68 vulnerabilities]
67

# now check the Kontain container image
$ grype kg/pyflask:1.0
 ✔ Vulnerability DB        [no update available]
 ✔ Loaded image
 ✔ Parsed image
 ✔ Cataloged packages      [8 packages]
 ✔ Scanned image           [0 vulnerabilities]
No vulnerabilities found
```

## Kubernetes
### Kubernetes Deployment Manifest
The K8s deployment yaml (flaskapp_k8s.yml) along with the service at port 5000 is shown below:
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

### Deploy to Kubernetes
```sh
$ kubectl apply -f flaskapp_k8s.yml

# verify that the pod is running
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
flaskapp-955645cf8-mfrtj            1/1     Running   0          15m
```

### Verify Deployment
Now we port forward the service's port to local port to test out that the service is running:
```sh
$ kubectl port-forward svc/flaskapp 5000:5000

# please note that you have to keep this terminal window open before the next step
```

In another terminal window we test using curl to verify the output from the service:
```sh
$ curl http://localhost:5000
Hello from Kontain!
```

Above we see the output from our Python app wrapped in a Kontain based image.

To clean up:
```sh
$ kubectl delete -f flaskapp_k8s
```
