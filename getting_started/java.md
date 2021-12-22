---
label: Java (Spring Boot)
icon: /images/java.png
order: 600
---

# Java
Below is an example of packaging and running a Spring Boot Application as a Kontain based Container.

Given a simple Spring Boot application with a tree structure as outlined below:

### The Spring Boot application and Maven files
```bash
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

## Dockerfile
```docker
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
CMD [ "java", "-jar", "app.jar" ]
```

## Spring Boot Application
Application:
```java
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

And the Controller:
```java
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

## Maven build
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
			http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <artifactId>spring-boot-hello</artifactId>
    <packaging>jar</packaging>
    <name>Spring Boot Hello World Example</name>
    <version>1.0</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.5.5</version>
    </parent>

	<properties>
		<java.version>11</java.version>
	</properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <!-- versions plugin $ mvn versions:display-plugin-updates -->
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>versions-maven-plugin</artifactId>
                <version>2.5</version>
                <configuration>
                    <generateBackupPoms>false</generateBackupPoms>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>
```

### To build
Below we build, test, package the application using:

```bash
$ mvn clean test package
```

This produces an executable jar file target/spring-boot-hello-1.0.jar that can be run using:

```bash
$ java -jar target/spring-boot-hello-1.0.jar
```

## Docker
### Build Container Image
```bash
$ docker build -t kg/springboothello:latest .
```

### Run using Docker
```bash
$ docker run --rm --runtime=krun  -p 8080:8080  kg/springboothello:latest
...
...
```

In another terminal we run:
```bash
$ curl http://localhost:8080/
Hello from Kontain!
```

## Kubernetes
### Kubernetes Deployment Manifest
The K8s deployment yaml (flaskapp_k8s.yml) along with the service at port 8080 is shown below:
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: springboothello
  labels:
    app: springboothello
spec:
  type: ClusterIP 
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: springboothello
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboothello
  labels:
    app: springboothello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: springboothello
  template:
    metadata:
      labels:
        app: springboothello
    spec:
      runtimeClassName: kontain
      containers:
      - name: springboothello
        image: sandman2k/springboothello:1.0
        ports:
        - containerPort: 8080
```

### Deploy to Kubernetes
```sh
$ kubectl apply -f k8s.yml
service/springboothello created
deployment.apps/springboothello created

# verify that the pod is running
$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
flaskapp-955645cf8-9sqm5           1/1     Running   0          146m
springboothello-6b5b5f7d6b-2vb48   1/1     Running   0          22m

```

### Verify Deployment
Now we port forward the service's port to local port to test out that the service is running:
```sh
$ kubectl port-forward svc/springboothello 8080:8080

# please note that you have to keep this terminal window open before the next step
```

In another terminal window we test using curl to verify the output from the service:
```sh
$ curl http://localhost:8080
Hello from Kontain!
```

Above we see the output from our Java Spring Boot app wrapped in a Kontain based image.

If you wish to delete Spring Boot app from your Kubernetes distribution you can use:
```sh
$ kubectl delete -f k8s.yml
```
