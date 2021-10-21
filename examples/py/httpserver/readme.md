# reference
```bash
# build and run the container
$ docker build -t kg/httpserver .
$ docker run --runtime=krun -p 8080:8080 --rm kg/httpserver
# use Ctrl-\<enter> to exit the container

# run the http curl client in another shell terminal
$ curl -s -I http://localhost:8080
$ curl -s -d "some_stuff=good&other_stuff=bad" http://localhost:8080
```