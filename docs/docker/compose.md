# Usage with Docker-compose

To use a service that is bundled as a Kontain Container with Docker-compose you can use the Docker-compose stanza for runtime as shown below:

```yaml
services:
  myapp:
    image: <image-name>
    command: <command>
    runtime: krun

```

Note the use of the runtime element in the compose yaml to specify the runtime as krun from Kontain.
