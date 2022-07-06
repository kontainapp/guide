---
label: FAQ
icon: /images/logo2.png
order: 700
---

### **Does Kontain run Docker containers without modifications?**

Yes, it runs Docker containers without any modifications securely.

But if you would like more benefits, you can leverage Kontain's smaller resources/image sizes capabilities with a little bit more effort in your Dockerfile construction, and can also use its instant start capabilities for your slower containers.

### **How do I run a Docker Container using Kontain?**

Kontain runs whenever used as a runtime in docker or Kubernetes.  The following is an example of this:

```shell
$ docker run -runtime=krun hello-world
```

Here is an example of [Kontain in docker-compose](https://github.com/kontainapp/guide-examples/blob/master/examples/go/golang-http-hello/docker-compose.yml), and [in Kubernetes](https://github.com/kontainapp/guide-examples/blob/master/examples/go/golang-http-hello/k8s.yml)

### **Which languages does it support?**

The Default is English (United States), but it is not language dependent, so should work anywhere where Docker or Kubernetes works.

### **Can it run on my desktop?**

Yes, you can with the following Linux Operating Systems. If you are running Ubuntu 20.04 or above or Fedora 34 or above or Amazon Linux 2 with Kernel version 5.10 or above, it is very easy to install Kontain.

If you ensure that you have docker pre-installed, you can just use:

```shell
$ curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash
```

For more detailed instructions, you can refer to this [link](/getting_started/install_linux/).

For running on a Windows 10 or above desktop, you can use Vagrant with Hyper-V as outlined [here](/getting_started/windows/)

For running on a Mac OS desktop, you can use *brew* to install Vagrant and install Kontain as outlined [here](/getting_started/mac_os/)

### **How does it work?**

Kontain works by adding a secure CRI-compliant Container runtime to Containerd, that is used by both Docker and Kubernetes to run containers. 

By working with Containerd, the user just has to specify *–runtime=krun* in Docker or *runtime:kontain* in Kubernetes for a container to run in Kontain alongside other containers.

### **Where can I use it or What platforms does it run on?**

Kontain runs anywhere that *Linux, Docker and Kubernetes runs, including AWS, Azure and Google Cloud and on-premises* installations. It can be installed *as a secure runtime for Docker/Containerd in desktops, VMs, Kubernetes*.

### **Is it easy to install?**

As seen above, so long as you are running the requisite OS with KVM enabled and docker installed, it is [very easy to install](/getting_started/install_linux.md).

### **How do I use it easily in 2 minutes?**

Once you have it installed as shown above, you can use it to run a docker container as shown
below:

```shell
$ docker run -runtime=krun hello-world
```

### **Why should I use it over Docker for running my container?**

Kontain:
- secures a container with VM-level hardware isolation
- provides smaller images thus consuming less resources,
- without changing your CI/CD workflow/tools.
- In addition, it provides instant start capabilities for your slow starting Docker containers.
- Also, it runs alongside Docker containers in Docker-compose and Kubernetes, hence
you can try out Kontain incrementally.

### **Does it work with docker-compose?**

Yes, you just have to add the line “runtime: krun” to docker-compose.yaml file.
Here’s an example of Kontain in a docker-compose.yml file.
It can run side by side with existing Docker containers, so you don’t have to run
Here’s an example of Kontain in a Kubernetes manifest.
It runs side by side with Docker containers.

### **Is it open source?**

Yes

### **Is it free to try and use?**

Yes