# reference
```bash
# build and run the container
$ docker build -t kg/pyflask .
$ docker run --runtime=krun -p 5000:5000 --rm kg/pyflask
# use Ctrl-\<enter> to exit the container

# run the http curl client in another shell terminal
$ curl -s -I http://localhost:5000/

# check size of image
$ docker images
python-slim........122MB
python-bullseye....915MB

# note the sizes of the Kontain python runtime image and 
#     the Python flask server Kontain container image
runenv-python......23.5MB
kg/pyflask.........40 MB
```

# Notes
The Dockerfile here uses a multi-stage docker build (https://pythonspeed.com/articles/multi-stage-docker-python/) for the following benefits:

* this allows us to use the traditional Docker build steps required for Python to install package requirements in a virtual environment as the preferred way to run Python applications
* allows us to copy over the virtual environment contents
* allows us to selectively copy over exactly the packaging requrements that Python would need to run the application
* the image size reduces from over a few hundred MB to about 40MB
