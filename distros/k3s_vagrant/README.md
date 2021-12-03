# helpful
# vagrant
https://fedoramagazine.org/vagrant-beyond-basics/

## vagrant and libvirt
https://fedoramagazine.org/vagrant-qemukvm-fedora-devops-sysadmin/
https://www.vagrantup.com/docs/multi-machine

## k3s and vagrant
https://akos.ma/blog/vagrant-k3s-and-virtualbox/

# Description
We deploy a multi-node cluster for K3s using Vagrant and K3s.

Please note that this has been built on a Fedora 34 machine with Vagrant deployed with Libvirt/KVM as the VM virtualization provider rather than VirtualBox.

The same should work on Vagrant with VirtualBox with "Nested Virtualization turned on".

# To deploy Vagrant on Fedora with libvirt as provider
https://fedoramagazine.org/vagrant-qemukvm-fedora-devops-sysadmin/

# to stand up the cluster and use it
```bash
$ up.sh
...
...

All deployed!! to leverage the new cluster you can do one of the following:
1. you can do either: $ export KUBECONFIG=./shared/server_details/kubeconfig
     and use the new cluster
or
2. you can add this as a new context ./shared/server_details/kubeconfig to your config at .kube config
```

# configuring kubectl to use the new cluster
```bash
$ export KUBECONFIG=./shared/server_details/kubeconfig
$ kubectl get po
```