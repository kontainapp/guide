---
label: Instantly starting your Spring Boot Application
icon: /images/java.png
order: 595
---

## Instantly starting Spring Boot microservice
How many times have you wished that your Spring Boot Java microservice would start instantaneously without any delay whatsoever? How many times did you wish you could scale down your Java Containers with faith that you would be able to relaunch them in an instant during a spike in request load.
If only a big heavy JVM could start as quick as those other language runtimes?
How many times did you wish you had tiny Java microservices that could be launched instantly on an event, respond to the event and shut down.
Did you wish you could shut down your service and launch it only when necessary without any "warm" up time?

Well, read on to see how we can do this with Kontain Containers.

## Video demo
### starting a Spring Boot Application the normal way
[!embed](https://youtu.be/jrg8mRHrafI)

### starting a Spring Boot microservice the "instant" way
[!embed](https://youtu.be/bwgVp1Hpybo)

## How do we do this?
### Install Kontain
To install Kontain on your Linux machine, you can follow the steps in the guide. Please note that you need a recent version of Fedora or Ubuntu OS (Linux kernel version 4.15 or newer) for this as specified in the guide.

### Reviewing the Spring Boot Application
We will use a very simple Spring Boot application as our example as shown below:

```
$ tree
├── Dockerfile
├── pom.xml
├── resources
│   └── placeholder.txt
└── src
    ├── main
    │   └── java
    │       └── com
    │           └── example
    │               ├── HelloController.java
    │               └── HelloWorldApp.java
    └── test
        └── java
            └── com
                └── example
                    └── HelloControllerTest.java
```

### Application files
The Spring Boot Application:

```
// HelloWorldApp.java
package com.example;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication
public class HelloWorldApp {
public static void main(String[] args) {
        SpringApplication.run(HelloWorldApp.class, args);
    }
}
```

### The Spring Boot Controller:

```
// HelloController.java
package com.example;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class HelloController {
@RequestMapping("/")
    String hello() {
        return "Hello from Kontain!";
    }
}
```

### Dockerfile
Its Dockerfile:

```
FROM openjdk:11-jdk-slim-buster as build
RUN mkdir -p /tmp
WORKDIR /opt/src/app
# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar
FROM kontainapp/runenv-jdk-11 as release
COPY --from=build /opt/src /opt/src
COPY --from=build /tmp /tmp
WORKDIR /opt/src/app
EXPOSE 8080
ENV KM_MGTPIPE=/tmp/km.sock
CMD [ "KM_MGTPIPE=/tmp/km.sock", "/opt/kontain/java/bin/java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]
```

### Build and Run
To build the code and the container, we can do:

```
$ mvn clean package test
$ docker build -t kg/springboothello:latest .
```

To run using Docker:

```
$ docker run --rm --runtime=krun -p 8080:8080  kg/springboothello:latest
...

```

As you can see, it takes a few seconds (about 9–10 seconds) before the Spring Boot Application starts up and is ready.

Now, let's serve a request from this Container just to verify.

```
$ curl http://localhost:8080
Hello from Kontain!
```

## Using an "Instastart" Container
### Prep for creating an "Instastart" Container
Now let's restart the application container with a few other parameters so that we can create an alternate "instantly" starting container for the same Spring Boot Application.

```
$ docker run --runtime=krun --name=KM_springboothello -p 8080:8080 -v /opt/kontain/bin/km_cli:/opt/kontain/bin/km_cli -v $(pwd):/mnt:rw kg/springboothello:latest
....
```

Serve a request to verify:

```
$ curl http://localhost:8080
Hello from Kontain!
```

### Creating an "Instastart" Container
Now let's take an Application Container Snapshot and copy it so as to create an "Instastart" container.

```
$ docker exec KM_springboothello /opt/kontain/bin/km_cli -s /tmp/km.sock
$ docker cp KM_springboothello:/opt/src/app/kmsnap .
$ chmod +x kmsnap
```

This will generate a kmsnap file with a re-usable Application Snapshot. Note that KM will report it as saving a core dump, since core dumps and snapshots have the same format and are generated using the same mechanism.

Now, let's package up the Snapshot as an "Instastart" Container. This bundles the Application Snapshot into a new Docker container that can be used to "instantly" run the Spring Boot application.

```
# build
$ docker build -t kg/springboothellosnap -f Dockerfile.snap .
```

### Running the "Instastart" Container
Now let's start up the "Instastart" Container:

```
# Run in terminal 1
$ docker run --runtime=krun --rm -it --name=KM_springboothello_snap -p 8080:8080 kg/springboothellosnap

# Run in terminal 2, you will "instantly" get a response

$ curl http://localhost:8080
Hello from Kontain!
```

You will notice that the container starts up instantly (with almost all of the overhead being Docker startup cost) and that the request gets a response "instantly" as well.

## Conclusion
"Instastart" provides a rather amazing opportunity for Java Spring Boot Containers to be scaled down to 0 during times when there are no events or when there no customers waiting for a request, and provides a way to respond "Instantly" and scale up when the request load suddenly spikes.

## Measuring start time approximately
This measurement is skewed by the method below because of I/O and Docker Container startup overhead but provides a way to measure relative start time.

For Instastart container:

```
# in terminal 1, run:
$ ./get_time.sh
```

```
# and in terminal 2, do:
$ touch start_time &docker run --rm --runtime=krun  -p 8080:8080  kg/springboothellosnap
```

For normal container:

```
# in terminal 1, run:
$ ./get_time.sh
```

```
# and in terminal 2, do:
$ touch start_time &docker run --rm --runtime=krun  -p 8080:8080  kg/springboothello
```
