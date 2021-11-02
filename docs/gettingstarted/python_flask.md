# Python

Below is a short example of bundling a python microservice in a Kontain-based Container with Docker:

app/hello.py:

```python
from flask import Flask
app = Flask(__name__)
 
@app.route("/")
def hello():
    return "Hello from Kontain!"
 
if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

Dockerfile:

```shell
FROM python:3.8-slim AS build
WORKDIR /opt/src/app
 
RUN python -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"
 
ADD . /opt/src/
RUN pip install -r /opt/src/requirements.txt
 
ADD app/main.py /opt/src/app/
#RUN find /opt/src/
 
 
FROM kontainapp/runenv-python as release
COPY --from=build /opt/venv /opt/venv
COPY --from=build /opt/src/app /opt/src/app
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/src/app
 
EXPOSE 5000
CMD ["python", "main.py"]
```

Build the Kontain Container image:

```sh
$ docker build -t kg/pyflask .
```

Run the Kontain pyflask microservice Container:

```sh
$ docker run --rm  --runtime=krun -p 5000:5000 kg/pyflask
$ curl http://localhost:5000/
Hello from Kontain!
```

Check out the size of the Kontain based image for Pyflask microservice with Python runtime, code and libraries - **40.2 MB**
- Size of the Base Python-slim Image without code and libraries - **122 MB**
- Size of the Python bullseye base image - **909MB**
