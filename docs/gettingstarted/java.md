# Java
Below is an example of packaging and running a Spring Boot Application as a Kontain based Container.

Given a simple Spring Boot application with a tree structure as outlined below:

### the Spring Boot application and Maven files
```bash
$ tree
├── Dockerfile
├── pom.xml
├── resources
│   ├── crunchify.xml
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

With a Dockerfile below:
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

With source below:
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

and a pom.xml like below:
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

and a test like below:
```java
package com.example;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest(classes = HelloWorldApp.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class HelloControllerTest {

    @Autowired
    private TestRestTemplate template;

    @Test
    public void hello_ok() throws Exception {
        ResponseEntity<String> response = template.getForEntity("/", String.class);
        assertThat(response.getBody()).isEqualTo("Hello from Kontain!");
    }

}
```
#### build and test
Below we build, test, package the application using:

```bash
$ mvn clean test package
```

This produces an executable jar file target/spring-boot-hello-1.0.jar that can be run using:

```bash
$ java -jar target/spring-boot-hello-1.0.jar
```

To package into a Kontain-based container image we use:
```bash
$ docker build -t kg/springboothello:latest .
```

To run the Kontain-based container image we use:
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