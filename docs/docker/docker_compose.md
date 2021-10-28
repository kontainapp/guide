# Usage with Docker-compose

To use Kontain with Docker-compose you can use the Docker-compose stanza for runtime as shown below:

```yaml
services:
  test:
    image: <image-name
    command: <command>
    runtime: krun

```

Note the use of the runtime element in the compose yaml to specify the runtime as krun from Kontain.
