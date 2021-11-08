import TOCInline from '@theme/TOCInline';

<TOCInline toc={toc} />;

# KKM
Kontain runs on Local, Azure, Google Cloud, and AWS Linux instances supporting “nested virtualization”, i.e. with KVM enabled.


![Kontain System Diagram](https://raw.githubusercontent.com/kontainapp/km/master/docs/images/kontain-system-diagram.jpg)


# Overview
Containerization tools and processes provide the foundation for deploying today’s cloud-native software applications, but containers are far from perfect for many modern workloads. For example, workloads that require very strong security isolation take on additional risk if they are run as containers on shared OS kernels. Some workloads need to scale up—then scale down to zero—much quicker, more easily, and more cost-effectively than is possible using standard containers.

Kontain leverages existing container workflows, development tools, and processes, but builds containers with special characteristics:

Each process in each container runs in its own private virtual machine (VM), providing security isolation and a small attack surface.

Each instance of each container starts fast—orders of magnitude faster than a regular VM, and close to the start time of a Linux process.

A smaller container image—sometimes much smaller—than a standard container.

Kontain is a way to run container workloads "secure, fast, and small – choose three."


# How Kontain Works
The Kontain solution integrates two foundational technologies: containers and unikernels.

A unikernel is a single-address-space machine image that contains an application workload—the program you want to run in a container—combined with a minimal set of library functions which provide the OS services required to run the workload.

Kontain provides a method for creating and running unikernels that are optimized for container use cases. Packaging this workload-optimized unikernel as an OCI-compliant container image yields what we call a kontainer.

A Kontain workload can be an unmodified Linux executable running as a unikernel or a unikernel created from source code relinked with Kontain libraries. No source code modification is needed to create a kontainer.

For compiled languages (e.g. C/C++, Go), a unikernel kontainer is created by linking application object code with Kontain libraries. For interpreted and bytecode-interpreted languages (e.g. Java, Python), a unikernel language runtime is created, then the interpreted code is run inside the unikernel. Kontain provides standard language runtime unikernels, but you can build your own if you prefer. In any case, the unikernel is much smaller and more efficient than a full OS kernel.

The Kontain solution includes a CRI-compatible runtime that, upon command, instantiates a virtual machine (VM) for the requested kontainer instance, loads the unikernel into the VM, then passes control to the unikernel.

Running a workload as a unikernel in a Kontain virtual machine provides VM-level isolation and security, with none of the overhead of a traditional VM.

A Kontain VM is optimized for container workloads. It provides just the virtual hardware needs (CPU and memory), so is much smaller than a standard VM. The VM interacts with the outside world via a limited set of hypercalls to the Kontain Monitor (KM).

By virtue of its small size and targeted functionality, a Kontain VM provides a secure environment for the application running inside. As an example, workloads running in a Kontain VM are immune to the Meltdown security flaw, even on unpatched kernels and CPUs.

Compatible with Existing Container Workflows
Kontain plugs into Docker and Kubernetes runtime environments. Kontain’s OCI-compliant image and CRI-compatible runtime deliver command-line and API compatibility with existing tools in your container workflow. Kontain requires little or no change to existing CI/CD systems, orchestration configurations, and monitoring systems.

# Kontain System Overview
In this section, we’ll take a closer look at the Kontain system components and how they work together to run workloads.

![Kontain System Diagram](https://raw.githubusercontent.com/kontainapp/km/master/docs/images/kontain-system-diagram.jpg)

krun can be invoked from Docker, Podman, and other container management tools.
krun can also be used to run kontainers directly.
A Kontain unikernel is the application code packaged with the Kontain runtime library. At runtime, this small, executable artifact runs in a Kontain VM.

Kontain provides tools to build unikernels that are optimized for container use cases. Packaging this workload-optimized unikernel as an OCI-compliant container image yields what we call a kontainer. For more information about kontainers, see “How Kontain Works with Docker,” below.

A Kontain unikernel can be created from any application, containerized or not:

In many cases, Kontain can run unmodified Linux binaries as a unikernel (e.g., statically linked Go programs and applications linked for Alpine Linux).
Some application code may need to be re-linked with a Kontain runtime library so it can be run as a unikernel.
The Kontain virtual machine Monitor (KM) is a user-space application that interfaces with underlying hardware via system calls. KM initializes Kontain VM facilities, loads the unikernel image into VM memory, and runs the workload inside the VM. This dedicated VM is ephemeral, existing only to support one instance of a kontainer.

The Kontain VM provides hardware resources (CPU, memory) to the application. Kontain VMs interact with the outside world via a limited set of hypercalls to the Kontain Monitor, which manages requests from the application as it runs.

A Kontain VM is optimized to provide the workload with just the features it needs to execute—mainly CPU and memory. The Kontain VM model dynamically adjusts to application requirements, for example, growing and shrinking memory to meet the application’s demands and adding and removing virtual CPUs as the application manipulates thread pools. The Kontain Monitor spawns additional KM processes as needed to manage dedicated VMs.

How Kontain Handles Syscalls
System calls are handled differently depending on how the Kontain unikernel is built. When running an unmodified Linux executable as a unikernel, Kontain will automatically use support that has been preloaded into the Kontain VM. This code performs a translation step, converting syscalls from the app to hypercalls that the Kontain VM can handle.

The Kontain runtime library does not use syscalls to request services as regular libraries—including musl and glibc—do. Instead, it uses ‘out’ command-based hypercalls. An application that has been linked with the provided Kontain runtime libraries will issue hypercalls directly to the Kontain Monitor (KM).

# Linux Platform Portability
Kontain runs on Linux hosts that meet these minimum requirements:

CPU: Intel or AMD
Linux kernel: Version 4.15 or higher (version 5.0 or higher if using KKM)
Distribution: Ubuntu 20 and Fedora 32 (or newer) are recommended
Virtualization enabled, using either:
Hardware virtualization with KVM installed and enabled (requires stock KVM kernel module on Linux kernel 4.15 or higher), or
Kontain Kernel Module (KKM), included in the Kontain release. KKM provides the virtualization facilities that KM needs in situations where hardware virtualization is unavailable or has been disabled, most notably AWS EC2.
Kontain in the Cloud
Kontain runs on Azure, Google Cloud, and AWS instances supporting “nested virtualization”, i.e. with KVM enabled.

Check with your cloud provider regarding nested virtualization support and configuration requirements. On AWS, only “metal” instances (e.g. i3.metal) enable nested virtualization. For user convenience, Kontain provides an AWS Ubuntu-based AMI pre-configured with Kontain, Docker, and KKM. See “Using a Kontain AMI on AWS.”


# Do I Need KVM or KKM?
On Linux development machines, Kontain can run on the machine directly, with KVM.

On OSX and Windows development machines, Kontain can be run in a Linux VM with either KVM module (nested virtualization) enabled or the KKM module installed. Support for nested virtualization depends on the hypervisor. KKM can be installed in the Linux VM if the hypervisor does not support nested virtualization.

Certain hypervisors and cloud providers do not support nested virtualization on a VM, or support it only on VMs that fall within a specific size or price range. Where KVM virtualization is unavailable, a VM with the Kontain kernel module (KKM) installed is needed to run Kontain.

In short, KKM enables nested virtualization wherever you can install a kernel module. KKM can co-exist with KVM if both are installed on the same box.

Kontain’s implementation of a OCI Runtime compliant container interface is krun (based on RedHat crun), which is used to build and run an application as a Kontain unikernel in a nested VM.

# How Kontain Works with Docker
NOTE: Although this section refers to using Kontain with Docker, Kontain works equally well with other container management tools, e.g. RedHat Podman.

You can use Docker to build and run a Kontain workload, as a unikernel, in a kontainer.

A kontainer is a Docker (OCI) container with a Kontain unikernel in the container image that is executed by the Kontain runtime (krun). As in a regular Docker workflow, a kontainer image is created using the docker build command.

A kontainer is run by invoking krun from docker run. To run a kontainer, Docker must be configured to use krun. See Runtime Config for Docker for instructions.

You can also run a Kontain workload as a Docker container with the default Docker runtime. This use model still provides the benefits of running a workload as a unikernel in a VM, but Docker startup overhead is still present. More importantly, docker exec and any subprocesses present will evade wrapping in a Kontain VM; instead, these will be executed outside of Kontain. Therefore, while this method can be useful for testing, it is not recommended for production.

For more information, see Using Docker Runtime.

Additional Documentation and Support
KM command line help: /opt/kontain/bin/km --help
Debugging Kontain Unikernels
[Kontain FAQ}(FAQ.md)
