# reference
```bash
# build the container
$ docker build -t kg/hello1 .

# run the container
$ docker run --runtime=krun --rm kg/hello1
# Error: /hello.py is not an ELF object
# use Ctrl-\<enter> to exit the container
```