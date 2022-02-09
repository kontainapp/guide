# Hello world for Kontain
This is a quick way to verify that Kontain has been installed properly and works.

Run Kontain Monitor with a simple C program to test that Kontain Monitor is installed properly with virtualization requirements.

```shell
# check if Kontain Monitor can be used to run the 'Hello Kontain' C program
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

Now, lets verify docker integration.
```shell
# lets verify with Docker
$ cp /opt/kontain/tests/hello_test.km .

# use a Dockerfile to bundle this simple program
$ cat Dockerfile
FROM scratch
ADD hello_test.km /
ENTRYPOINT ["/hello_test.km"]
CMD ["from", "docker"]

# build the image
$ docker build -t try-kontain .

# run with kontain as the runtime
$ docker run --runtime=krun --rm try-kontain:latest
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'

# this verifies that Kontain is being used as a runtime in Docker
```