---
label: Quick start
icon: /images/docker.png
order: 1950
---

## Install Kontain and run Docker images with Kontain
Assuming that you are on a Linux system (either Ubuntu 20.04 or Amazon Linux 2 with Kernel version 5.10 or above or Fedora 34 and above) with [KVM enabled](https://phoenixnap.com/kb/ubuntu-install-kvm), and [Docker](https://docs.docker.com/engine/install/ubuntu/) installed, we can install Kontain witn the following command:

```shell
# verify that kvm is installed
$ ls -l /dev/kvm

# verify that docker is installed
$ systemctl|grep docker.service

# download and install
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash
...

# verify install by checking if kontain folder was created
$ ls /opt/kontain

# run the classic docker hello-world image using Kontain
$ docker run --runtime=krun hello-world
Hello from Docker!
...

# run java hello world image
$ docker run --runtime=krun kontainguide/java-hello-world
Hello world from Kontain!
```

[!ref text="Install Kontain in Linux"](/getting_started/install_linux)

## Using Kontain with golang, Java Spring Boot, Python FastAPI, and NodeJS
Below we will some examples of how to use Kontain with golang, Java Spring Boot, Python FastAPI and NodeJS without changing any of your existing Docker or Kubernetes workflows.  

For more details, you can view the [examples repository](https://github.com/kontainapp/guide-examples) or view the docs for each - [Go](/getting_started/golang), [Java](/getting_started/java), [Python](/getting_started/python), [NodeJS](/getting_started/javascript)


```shell
# clone the examples repository
$ git clone https://github.com/kontainapp/guide-examples.git

#---------------------
# let's run a golang server program
$ cd guide-examples/examples/go/golang-http=hello

# build the image
$ docker build -t kontainguide/golang-http-hello .

# lets run this
$ docker run -d --rm -p 8080:8080 --runtime=krun --name golang-http-hello kontainguide/golang-http-hello
$ docker ps
CONTAINER ID   IMAGE                            COMMAND     CREATED         STATUS         PORTS                                       NAMES
1c897d79f36e   kontainguide/golang-http-hello   "/server"   3 seconds ago   Up 2 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   golang-http-hello

# invoke the service
$ curl http://localhost:8080
Hello World!

$ docker stop golang-http-hello

#---------------------
# let's run a java spring boot hello world program
$ cd guide-examples/examples/java/java-hello-world/

# build the image
$ docker build -t kontainguide/spring-boot-hello .

# now run this
docker run -d --rm -p 8080:8080 --runtime=krun --name spring-boot-hello kontainguide/spring-boot-hello
docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED         STATUS         PORTS                                       NAMES
445f87eb70bd   kontainguide/spring-boot-hello:1.0   "java -XX:-UseCompre…"   5 seconds ago   Up 5 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   spring-boot-hello


# invoke the service
$ curl http://localhost:8080
Hello from Kontain!

# stop the service
$ docker stop spring-boot-hello

#---------------------
# now let's run a Flask python example
$ cd guide-examples/examples/python/py-flask-hello

# now let's build this example
$ docker build -t kontainguide/py-flask-hello .
$ docker run -d --rm -p 8080:8080 --runtime=krun --name fastapi-hello kontainguide/fastapi-hello
$ docker ps
CONTAINER ID   IMAGE                         COMMAND            CREATED          STATUS          PORTS                                       NAMES
d89b1dff1249   kontainguide/fastapi-hello   "uvicorn app.main:ap…"   51 seconds ago   Up 51 seconds   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   fastapi-hello

$ curl  http://localhost:8080
{"Hello":"Kontain!"}

# now let's stop the FastAPI container
$ docker stop fastapi-hello

#---------------------
# now let's run a NodeJS express service
$ cd guide-examples/examples/js/node-hello-world
$ docker build -t kontainguide/node-hello-world .

# run the example using Kontain
$ docker run --rm --runtime=krun -d -p 3000:3000 --name node-hello-world kontainguide/node-hello-world
$ docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS                                       NAMES
6bb15f7c03db   kontainguide/node-hello-world   "docker-entrypoint.s…"   5 seconds ago   Up 4 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   node-hello-world

# invoke the service
$ curl http://localhost:3000
Hello World!

# now let's stop the nodejs container
$ docker stop node-hello-world
```