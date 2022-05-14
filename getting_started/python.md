---
label: Python Flask and FastAPI (Docker/Compose/K8s)
icon: /images/python.png
order: 900
---

## Example of using Kontain with a Python Flask-based Service
This example shows how to build, push, run a Python Flask based microservice in a Kontain container in Docker and Kubernetes.

[The implementation of this example is here](https://github.com/kontainapp/guide-examples/tree/master/examples/python/py-flask-hello) along with instructions to build and run this example.

### to build this example
```bash
$ docker build -t kontainguide/py-flask-hello:1.0 .
```

### see image sizes
```bash
$ docker images|grep python
kontainapp/runenv-python-3.9 latest               793bfa36a196   2 days ago          24.1MB
python                       3.8-slim             5ce3cfb9de89   8 days ago          124MB
python                       3.9-slim             8c7051081f58   8 days ago          125MB
kontainapp/runenv-python-3.8 v0.9.1               aee035a4b2bc   7 months ago        23.5MB
```

**Please note that the Kontain based container is 23.5MB in size versus the "Slim" python-slim base container**

### to run this example
```bash
$ docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello kontainguide/py-flask-hello:1.0

# invoke the service
$ curl -v http://localhost:5000

$ docker stop py-flask-hello
```

### to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:5000

# shut down compose
$ docker-compose down
```

### to run this example in kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port in 1 terminal
$ kubectl port-forward svc/py-flask-hello 5000:5000 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```

## Example of using Kontain with a Python FastAPI-based Service
This example shows how to build, push, run a Python FastAPI based microservice in a Kontain container in Docker and Kubernetes.

The difference between this and the Flask API based example is that we run the Docker image as is without any conversion to Kontain based containers, but yet provide a secure environment. Thus this does not reduce the size but enables the convenience of using current containers as-is without any changes.

[The implementation of this example is here](https://github.com/kontainapp/guide-examples/tree/master/examples/python/fastapi-hello) along with instructions to build and run this example.

### to build this example
```bash
$ docker build -t kontainguide/fastapi-hello:1.0 .
```

### to run this example
```bash
$ docker run -d --rm -p 5000:5000 --runtime=krun --name fastapi-hello kontainguide/fastapi-hello:1.0
```

### invoke the service
$ curl -v http://localhost:5000

$ docker stop fastapi-hello
```

# to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:5000

# shut down compose
$ docker-compose down
```

### to run this example kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/fastapi-hello 5000:5000 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```

### reference
[https://fastapi.tiangolo.com/deployment/docker/](https://fastapi.tiangolo.com/deployment/docker/)