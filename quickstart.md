---
label: Quick start
icon: /images/docker.png
order: 1950
---

## Install Kontain and run Docker images with Kontain
Assuming that you are on a Linux system (either Ubuntu 20.04 or Amazon Linux 2 with Kernel version 5.10 or above or Fedora 34 and above) with KVM enabled, we can install Kontain witn the following command:

```shell
# download and install
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash
...

# verify install by checking if kontain folder was created
$ ls /opt/kontain

# run classic docker hello-world image using Kontain
$ docker run --runtime=krun hello-world

# run Java hello world using Kontain
$ docker run --runtime=krn
```


## Kontain running sample Docker images
Below we show a quick short demo of Kontain running docker "hello-world", Java Spring Boot, Python fastapi images to illustrate how easy it is to use Kontain.

![demo](/images/docker_run_demo.gif)

On Ascii Cinema:
[![asciicast](https://asciinema.org/a/5YK4OiEBn6pHoli8t5RqIhTqt.svg)](https://asciinema.org/a/5YK4OiEBn6pHoli8t5RqIhTqt?speed=3&t=1)
