---
label: Kubernetes Integration Overview
icon: gear
order: 900
---

## Kontain Integration with Kubernetes

Since Kontain is OCI Compatible like Docker, we can also use it with any distribution of Kubernetes that supports Containerd or CRI-O runtimes, and use familiar Kubernetes development and CI/CD workflows and tools to deploy Kontain-based Images as pods.

Below we show how a kubelet in a Kubernetes Worker node interacts with an implementation of the CRI (Containerd or CRI-O) to launch OCI compatible containers.  Below we show how Kontain’s krun interacts with the CRI implementations to launch containers in Kubernetes.

Below we show how kubelet on Kubernetes worker nodes works with CRI implementation runtimes (Containerd and CRI-O) and OCI to support multiple runtimes.

![Kubelet CRI and OCI](/images/kubelet-CRI-OCI.png)

Kontain's 'krun' can work with either Containerd or CRI-O runtimes that manage the complete container lifecycle.  Below we show more details on how this works.

![kubelet krun](/images/kubelet-krun.png)

![CRI krun](/images/kubelet-CRI-krun.png)
