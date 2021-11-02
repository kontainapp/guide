# Usage with Docker-compose
Below we show how Kontain works with Docker compose as well just like regular Docker images.  We extend the [Python Flask Microservice example](/gettingstarted/python_flask) to build and run it using Docker compose and invoke the http microservice using curl.

Below is the Docker Compose file for running the Kontain-based micoservice.  Please note the use of the *runtime* stanza in the Docker Compose yaml.  This indicates to Docker compose to run this microservice using the **Kontain (krun)** runtime, rather than the default **runc** runtime.


docker-compose.yml:
```yaml
version: "3"

services:

  # build 1
  app:
    runtime: krun
    build:
      context: .
      args:
        - BUILD_IMAGE_VERSION=python:3.8-slim
        - KONTAIN_RELEASE_IMAGE_VERSION=kontainapp/runenv-python
    environment:
      - ENV=development
    ports:
      - 5000:5000
    command: |
      python main.py
```


Below is the Dockerfile used to build the Microservice Kontain image.  We use Dockerfile args to abstract the build and release images versions.


```docker
ARG BUILD_IMAGE_VERSION
ARG KONTAIN_RELEASE_IMAGE_VERSION

FROM $BUILD_IMAGE_VERSION AS build
WORKDIR /opt/src/app

RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

ADD . /opt/src/
RUN pip install -r /opt/src/requirements.txt

ADD app/main.py /opt/src/app/
#RUN find /opt/src/


FROM $KONTAIN_RELEASE_IMAGE_VERSION as release

COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/src/app /opt/src/app
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/src/app

EXPOSE 5000
CMD ["python", "main.py"]
```


Now, we build and run the microservice using Docker compose commands:
```bash
# build the image
$ docker-compose build


# run the compose file
$ docker-compose up
Recreating pyflask_app_1 ... done
Attaching to pyflask_app_1
app_1  | python: dlopen: failed to find registration for /opt/venv/lib64/python3.8/site-packages/markupsafe/_speedups.cpython-38-x86_64-linux-gnu.so, check if it was prelinked
app_1  |  * Serving Flask app 'main' (lazy loading)
app_1  |  * Environment: production
app_1  |    WARNING: This is a development server. Do not use it in a production deployment.
app_1  |    Use a production WSGI server instead.
app_1  |  * Debug mode: off
app_1  |  * Running on all addresses.
app_1  |    WARNING: This is a development server. Do not use it in a production deployment.
app_1  |  * Running on http://172.18.0.2:5000/ (Press CTRL+C to quit)
app_1  | 172.18.0.1 - - [02/Nov/2021 01:17:03] "GET / HTTP/1.1" 200 -


# in another terminal window, use curl to call the microservice and verify
$ curl http://localhost:5000/
Hello from Kontain!
```