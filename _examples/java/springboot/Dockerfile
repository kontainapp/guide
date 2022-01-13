FROM openjdk:11-jdk-slim-buster as build
# RUN mkdir -p /tmp
WORKDIR /opt/src/app

# copy jar
COPY target/spring-boot-hello-1.0.jar app.jar

FROM kontainapp/runenv-jdk-shell-11.0.8:latest as release
COPY --from=build /opt/src /opt/src
# COPY --from=build /tmp /tmp

WORKDIR /opt/src/app

EXPOSE 8080
ENV KM_MGTPIPE=/tmp/km.sock
CMD [ "java", "-XX:-UseCompressedOops", "-jar", "/opt/src/app/app.jar" ]