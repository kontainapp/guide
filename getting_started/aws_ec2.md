---
label: Using Kontain on AWS EC2
icon: /images/windows_os_logo_icon.png
order: 220
---
# Using Kontain on AWS EC2
## Using a Kontain AMI (Amazon Linux 2 OS)
You can launch an AWS EC2 instance with Kontain pre-installed using the AMI id: 
- *ami-029f3a63da2a4503a* (kontain-v0.1test-amzn2-ami-kernel-5.10-hvm-2.0.20220121.0-x86_64-gp2) in us-west-2 region.

This AMI is based on the latest Amazon Linux 2 AMI and has Kontain v0.9.5 pre-installed.  You will need to select your own instance type, default VPC, subnets, IAM roles for your instance.  After you launch your own instance you can try out the examples in the docs below.

We can also easily add other AMIs based on AMI preference types on feedback.

==- Video: Launch an Amazon AMI Linux 2 VM with Kontain pre-installed
[!embed](https://youtu.be/YX8sUiFyb2k)
===

## Or, Install on your own Amazon Linux 2 based AWS EC2 VM
Please note that this requires an Amazon Linux 2 based VM with Kernel version above 5.10.

==- Tip: Installing Docker in Amazon Linux 2 if not present
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
===

```bash
# verify that its an Amazon linux 2 OS with kernel 5.10 or above
$ uname -a

# verify that docker is installed
$ sudo systemctl status | grep docker

# Update your OS
$ sudo yum update -y

# install kontain
$ curl https://raw.githubusercontent.com/kontainapp/guide/main/_scripts/kontain_bin_install.sh | sudo bash

# Verify by running "Hello, Kontain!"
$ /opt/kontain/bin/km /opt/kontain/tests/hello_test.km Hello, Kontain!

# Now, lets verify docker integration. Run the following in 1 terminal:
$ docker run --rm --runtime=krun kontainguide/hello-kontain
Hello, world
Hello, argv[0] = '/hello_test.km'
Hello, argv[1] = 'from'
Hello, argv[2] = 'docker'

# this verifies that Kontain is being used successfully as a runtime in Docker
```
