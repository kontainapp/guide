# reference
A full example with DB: https://medium.com/swlh/python-with-docker-compose-fastapi-part-2-88e164d6ef86

```bash
# build and run the container
$ docker build -t kg/pyflask .
$ docker run --runtime=krun -p 5000:5000 --rm kg/pyflask
# use Ctrl-\<enter> to exit the container

# run the http curl client in another shell terminal
$ curl -s -I http://localhost:5000/
```

# Notes
The Dockerfile here uses a multi-stage docker build (https://pythonspeed.com/articles/multi-stage-docker-python/) for the following benefits:

* this allows us to use the traditional Docker build steps required for Python to install package requirements in a virtual environment as the preferred way to run Python applications
* allows us to copy over the virtual environment contents
* allows us to selectively copy over exactly the packaging requrements that Python would need to run the application
* the image size reduces from over a few hundred MB to about 40MB
