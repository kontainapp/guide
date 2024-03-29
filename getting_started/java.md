---
label: Java (Spring Boot) in Docker/Compose/K8s
icon: /images/java.png
order: 600
---

## Example of using Kontain with a Spring Boot Microservice
Below is an example of packaging and running a Spring Boot Application as a Kontain based Container and run in Docker, Compose and Kubernetes.

The [implementation of this example is here](https://github.com/kontainapp/guide-examples/tree/master/examples/java/spring-boot-hello) along with instructions to build and run the example in Docker, compose and kubernetes.

### to build this example
```bash
$ docker build -t kontainguide/spring-boot-hello:1.0 .
```

### see image sizes
```bash
$ docker images | grep -E 'spring|jdk'
...
openjdk                            11-jdk-slim-buster  422MB
kontainapp/runenv-jdk-shell-11.0.8 latest              179MB
kontainguide/spring-boot-hello     1.0                 197MB
...
```

**Please note the image size of the base container at 422MB and that of the Kontain container at 197MB.**

### to run this example
```bash
$ docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello:1.0

# invoke the service
$ curl -v http://localhost:8080

$ docker stop spring-boot-hello
```

### to run this example in docker-compose
```bash
$ docker-compose up -d

# invoke the service
$ curl -v http://localhost:8080

# shut down compose
$ docker-compose down
```

### to run this example in kubernetes
```bash
$ kubectl apply -f k8s.yml

# check that the pod is ready
$ kubectl get pods -w

# port-forward the port
$ kubectl port-forward svc/spring-boot-hello 8080:8080 2>/dev/null &

# invoke the service
$ curl -vvv http://localhost:8080

# kill the port-forward
$ pkill -f "port-forward"
```