---
label: Quick start
icon: /images/docker.png
order: 1950
---

### Description
You can use Kontain to run existing or new Docker Images standalone or in Kubernetes with 
* secure VM-level hardware isolation
* reduce resource usage by building smaller Container images to reduce resource consumption
* and enable instant start capabilities for your slower starting contianers in Docker and Kubernetes

### Install Kontain and run existing Docker Container images with Kontain
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

# run the ubuntu Docker container image and echo a string
$ docker run --runtime=krun ubuntu echo hello world
hello world

# run a java hello world image
$ docker run --runtime=krun kontainguide/java-hello-world
Hello world from Kontain!

# run a C-based example
$ docker run --runtime=krun kontainguide/hello-kontain
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'
```
For more details, you can view the [examples](https://github.com/kontainapp/guide-examples/examples) or view the docs for each language using the links below.
[!ref text="Kontain examples repo"](https://github.com/kontainapp/guide-examples)

For more details on Install:
[!ref text="Install Kontain in Linux"](/getting_started/install_linux)

For more details to install Kontain as a secure runtime in Kubernetes:
[!ref text="Install Kontain in Kubernetes"](/getting_started/kubernetes)

Below we will some examples of how to use Kontain with golang, Java Spring Boot, Python Flask and NodeJS without changing any of your existing Docker or Kubernetes workflows.  

### Using Kontain with Golang http server (Docker Container)
[!ref text="Kontain and Go (Docker and Kubernetes)"](/getting_started/golang)

```shell
# clone the examples repository
$ git clone https://github.com/kontainapp/guide-examples.git

#---------------------
# let's run a golang server program
$ cd guide-examples/examples/go/golang-http-hello

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
```

### Using Kontain with a Java Spring boot service (Docker Container)
[!ref text="Using Kontain with Java/Spring Boot (Docker and Kubernetes)"](/getting_started/java)

```shell
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
```

### Using Kontain with a Python Flask service (Docker Container)
[!ref text="Using Kontain with Python/Flask (Docker and Kubernetes)"](/getting_started/python)

```shell
# now let's run a Flask python example
$ cd guide-examples/examples/python/py-flask-hello

# now let's build this example
$ docker build -t kontainguide/py-flask-hello .
$ docker run -d --rm -p 5000:5000 --runtime=krun --name py-flask-hello kontainguide/py-flask-hello
$ docker ps
CONTAINER ID   IMAGE                         COMMAND            CREATED          STATUS          PORTS                                       NAMES
45377d5dec4d   kontainguide/py-flask-hello   "python main.py"   6 seconds ago   Up 6 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   py-flask-hello

$ curl  http://localhost:5000
Hello Kontain!

# now let's stop the python flask container
$ docker stop py-flask-hello
```

### Using Kontain with a NodeJS Express service (Docker Container)
[!ref text="Using Kontain with NodeJS/Express (Docker and Kubernetes)"](/getting_started/javascript)

```shell
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
