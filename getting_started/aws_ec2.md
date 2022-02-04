---
label: Using Kontain on AWS EC2
icon: /images/windows_os_logo_icon.png
order: 979
---

#### AWS EC2 VM from AMI
To use Kontain on an AWS EC2 VM, you can either:
- you can use an existing Kontain AMI with **Kontain pre-installed**
- or install Kontain on a VM of your own if its one of the following (with kernel version above 4.15)
    - Fedora
    - Ubuntu
    - Amazon Linux 2

Below we will show how for both the cases.

+++ Using a Kontain AMI (Amazon Linux 2 OS)
You can launch an AWS EC2 instance using the AMI id: 
- *ami-0d66d35fafb795112* (kontain-v0.9.5-amazon-linux-2-hvm-64-bit-x86-ami-06cffe063efe892ad) in us-west-2 region.

This AMI is based on the latest Amazon Linux 2 AMI but has Kontain v0.9.5 pre-installed.  You will need to select your own instance type, default VPC, subnets, IAM roles for your instance.  After your launch your own instance you can try out the examples in the docs below.

[!embed](https://youtu.be/YX8sUiFyb2k)

+++ installing on your Amazon Linux 2 based AWS EC2 VM
#### Optional: Install Docker
Instructions summarized from [here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html)

```bash
# login to your instance
$ ssh ec2-user@<instance-ip-address>

# install Docker
$ sudo yum update -y
$ sudo amazon-linux-extras install docker
$ sudo yum install -y docker
$ sudo systemctl enable docker

# enable docker for non root user
$ sudo usermod -a -G docker ec2-user

# log out and log back in or do
$ newgrp docker
$ sudo service docker start

# verify docker install
$ docker run hello-world

# Optional: installing docker-compose
$ wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
$ sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
$ sudo chmod -v +x /usr/local/bin/docker-compose
```


#### Install Kontain
```bash
# install relevant packages
$ sudo yum install -y jq

# install KKM software virtualization module
$ curl -o kkm.run -L  https://github.com/kontainapp/km/releases/download/v0.9.5/kkm.run
$ chmod +x ./kkm.run && ./kkm.run

# install kontain monitor
$ sudo mkdir -p /opt/kontain ; sudo chown root /opt/kontain
$ curl -s https://raw.githubusercontent.com/kontainapp/km/master/km-releases/kontain-install.sh | sudo bash
```

+++ Verify Install
#### Verify that Kontain is installed
```shell
# check if Kontain Monitor is installed
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km
Hello, world
Hello, argv[0] = '/opt/kontain/tests/hello_test.km'
Hello, argv[1] = 'Hello,'
Hello, argv[2] = 'Kontain!'
```

```
# lets verify with Docker
$ cp /opt/kontain/tests/hello_test.km

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