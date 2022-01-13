---
label: Kontain vs similar technologies
icon: /images/k8s.png
order: 1100
---

## Kontain vs Firecracker vs gVisor and others
Below we have outlined some important concise information and differences on the System Architectures of Kontain vs gVisor and Firecracker, and how Kontain provides both security and high performance without any tradeoffs between the two.

## Kontain "Kontainer"
A Kontain "Kontainer" allows you to have the best combination of Performance, Strong Isolation and Security of Virtualization as well as a minimal footprint along with compatibility with Docker based tooling used to package and run Linux Containers.  

Kontain leverages a tiny footprint Virtual Machine Monitor (Kontain Monitor) which has an extremely minimalistic design that bundles the Application code with just the minimal set of System code just enough to run the Application in the same address space.  This enables the Application to startup faster than regular Linux Containers while also running extremely fast without context-switching to a OS Kernel.

This very significantly reduces the attack surface area and with strong VM-level isolation significatnly reduces the blast radius.

*Fig 1. A Traditional VM virtualization Architecture*
-![](/images/traditional-vm.png)

*Fig 2. Kontain System Architecture*
-![](/images/kontain-arch.png)

*Fig 3. Packaging and running Kontain "Kontainers"*
-![](/images/kontain-docker-packaging.png)

### **Pros**
* More secure and faster than Linux Containers while keeping compatibility with Docker and Kubernetes tooling and packaging
* Strong Security and isolation using same Virtualization techniques as regular VMs but with severely limited virtual hardware
  * Minimum footprint thus significantly reducing attack surface 
[Add link to container size]
  * high performance and [smaller/minimal footprint](https://kontainapp.github.io/guide/getting_started/python/#check-kontain-container-image-size) without sacrificing performance compared to Linux Containers
  * Targeting support for microservice/functions as a service model
* Fully compatible with Docker-based Tooling and Kubernetes thus requiring no change in Code or DevOps Tools
* Very thin redirector (less than 200 lines of code)
  * handles faults, signals and system calls
* Very tiny footprint Virtual Monitor (KM)
  * Kontain Monitor (KM) creates and configures the VMs
* Better security than containers, better performance than VMs
  * No forced choice between performance and safety
* No unnecessary hardware support other than CPU and Memory thus removing this attack vector
  * No support for BIOS and booting

### **Cons**
- Not trying to support monolithic legacy software
- No GPU support yet

## Firecracker
Firecracker is used by Amazon to run their AWS Lambda and other workloads.

-![](/images/lambda-arch.png)

### **Pros**
- Alternative to QEMU, Slimmed down VM with full Linux Kernel that’s run using Linux KVM
- Provides most “Heavy” OS/VM capabilities, does not use a shared Kernel (assuming you choose to run only one workload inside the VM, but you could still run >1 container inside a single Firecracker VM)
- Provides VM-level strong isolation using KVM hypervisor-based virtualized hardware 
- Provides OS-level services like a regular VM, though it has a smaller footprint than a regular VM
- Starts up much faster than a regular VM, but slower than a Linux Container

### **Cons**
- Does not use traditional Docker or Kubernetes based packaging to create OS images that also packages the application
- Provides a full OS thus increasing the attack surface vs Kontain, and if you run >1 workload per Firecracker VM increases the blast radius
- Smaller footprint than regular OS-based VM but ultimately you need a firecracker VM image in VM formats (qcow2, vhd etc.)
- Startup time includes minimal VM services startup time
- To speed up Application startup time to optimize for running Lambda functions, AWS possibly bundles some secret sauce that may not be included in Open source version.

## gVisor
gVisor is used by Google to run their CloudRun functions and other workloads.

-![](/images/gVisor-arch.png)

### **Pros**
- Lighter weight than a full-blown VM
- Uses a Completely different approach to isolation, using user space to sandbox and implement system calls thus not using a shared kernel
- Is available as a runtime within Docker, thus able to use Docker tooling
- Can deploy to Kubernetes
- Performance and Complexity increases since its an implementation of the kernel in Userland

### **Cons**
- Application code is run using 200,000+ lines of Golang code that implements the system calls of the Linux kernel
- So stronger security than Containers but likely to have lower performance, hence causing a tradeoff in security vs performance choice
- User space implementation choice has a performance cost over regular Docker containers as supported by their own [documentation](https://gvisor.dev/docs/architecture_guide/performance/) possibly because of context-switching between gVisor components and the host kernel
- Reports of performance costs even compared to packaging and running applications in VMs
- Has to context switch between system kernel and gVisor components
