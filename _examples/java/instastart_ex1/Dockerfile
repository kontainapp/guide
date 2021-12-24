FROM openjdk:11-jdk-slim-buster as build
RUN mkdir -p /tmp
WORKDIR /opt/src/app

# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar

FROM kontainapp/runenv-jdk-11.0.8:latest as release
COPY --from=build /opt/src /opt/src
COPY entrypoint.sh /entrypoint.sh

# COPY --from=build /tmp /tmp
ADD empty_tmp /tmp

WORKDIR /opt/src/app

EXPOSE 8080

#CMD [ "java", "-jar", "app.jar" ]
CMD [ "/entrypoint.sh" ]