---
label: k3s multi-node cluster lab
icon: /images/k3s.png
order: 600
---

## Overview
Below we use Vagrant to start a multi-node K3s cluster to test Kontain in K3s using Vagrant and libvirt as a provider since we are enabling nested virtualization using KVM.  

A more common use-case is to use VirtualBox as the Vagrant provider, but we haven't really so that will be left as an exercise for the user.

To install Kontain in K3s, we use the instructions from [here](http://localhost:5000/guide/getting_started/install/#on-a-k3s-edge-cluster)

## Requirements for Lab cluster with nested virtualization
We would need a Linux (ideally, Ubuntu or Fedora/Centos) machine with KVM virtualization installed as outlined [here](https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/)

After that, we installed Vagrant with libvirt as the provider as outlined [here](https://developer.fedoraproject.org/tools/vagrant/vagrant-libvirt.html).

## Bring up the cluster: vagrant up helper script
We provide a helper script below to install the server (master/control plane) node at first, and then to install the worker nodes (known as agents).

```
#!/bin/bash
# up.sh
set -euxo pipefail

# first, bring up the server
vagrant up server

sleep 10

# save server details post-provisioning for agent nodes to use
./scripts/save_server_details.sh

sleep 5

# bring up the agent
vagrant up agent1

echo "All deployed!! to leverage the new cluster you can do one of the following:"
echo "you do $ export KUBECONFIG=./shared/server_details/kubeconfig"
```

### kubectl
After bringng up the multi-node k3s cluster in Vagrant, you can use the following to run kubectl commands on the cluster:
```shell
$ export KUBECONFIG=`pwd`/shared/server_details/kubeconfig

$ kubectl get nodes -o wide
```

## The files
### save server details script
```
# save_server_details.sh
set -euxo pipefail

# get node-token for agent
vagrant ssh -c "sudo cat /etc/rancher/k3s/k3s.yaml" 2>/dev/null > ./shared/server_details/kubeconfig

# get node-token for agent
vagrant ssh -c "sudo cat /var/lib/rancher/k3s/server/node-token" 2>/dev/null > ./shared/server_details/node-token

# get IP
vagrant ssh server -c "hostname -I" 2>/dev/null | cut -d' ' -f2 > ./shared/server_details/server_ip

export SERVER_IP=$(cat ./shared/server_details/server_ip)
echo $SERVER_IP

# replace IP in kubeconfig
sed -i 's/127\.0\.0\.1/'"$SERVER_IP"'/g' ./shared/server_details/kubeconfig
```

### VagrantFile
The Vagrant file that stands up both the Server VM and Agent VM (worker node) is given below:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :
# check network IP CIDR with virsh first
# sudo virsh net-dumpxml default (normally: 192.168.122.10)

server_ip = "192.168.122.10"

# not using fixed IPs right now as libvirt provider has not been figured out
agents = { "agent1" => "192.168.122.20",
    }

#system("virsh net-update my-network add ip-dhcp-host \"<host mac='52:54:00:fb:95:91' ip='10.11.12.13' />\" --live --config")


# Extra parameters in INSTALL_K3S_EXEC variable because of
# K3s picking up the wrong interface when starting server and agent
# https://github.com/alexellis/k3sup/issues/306

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804" #"generic/alpine314"

  config.vm.define "server", primary: true do |server|
    server.vm.network :public_network, ip: server_ip, dev: "virbr0", mode: "bridge", type: "bridge"
    server.vm.synced_folder "./shared", "/vagrant", type: "rsync",
      rsync__exclude: ".git/"

    # add ssh - hangs
    # config.ssh.private_key_path = "~/.ssh/id_rsa"
    # config.ssh.forward_agent = true

    server.vm.hostname = "server"
    server.vm.provider "libvirt" do |vb|
      vb.nested = true
      vb.cpu_mode = "host-passthrough"
      vb.memory = "2048"
      vb.cpus = "2"

      # turn off inputs
      vb.inputs = []
    end

    args = []
    # server.vm.provision "shell", inline: server_script
    server.vm.provision "k3s shell script", type: "shell",
        path: "scripts/k3s_server_provisioning.sh",
        args: args
  end

  agents.each do |agent_name, agent_ip|
    config.vm.define agent_name do |agent|
      agent.vm.network :public_network, ip: agent_ip, dev: "virbr0", mode: "bridge", type: "bridge"
      agent.vm.synced_folder "./shared", "/vagrant", type: "rsync",
        rsync__exclude: ".git/"

      agent.vm.hostname = agent_name
      agent.vm.provider "libvirt" do |vb|
        vb.nested = true
        vb.cpu_mode = "host-passthrough"
        vb.memory = "1024"
        vb.cpus = "2"
      end

      # agent.vm.provision "shell", inline: agent_script
      args = []
      agent.vm.provision "k3s agent shell script", type: "shell",
      path: "scripts/k3s_agent_provisioning.sh",
      args: args
  end
  end
end
```

### Server Provisioning script
The server provisioning script referred to in the Vagrantfile is given below:

```shell
set -euox pipefail
sudo -i

# echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
#hostname -I | cut -d' ' -f2 2>/dev/null > /vagrant/SERVER1_IP

chmod +x /dev/kvm
sed -i 's/DNSSEC=yes/DNSSEC=no/1'  /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service
apt-get -y update

ufw allow 6443/tcp

echo "**** Begin installing k3s"

SERVER_IP="192.168.122.10"
# INSTALL_K3S_EXEC="--bind-address ${SERVER_IP} --node-external-ip ${SERVER_IP} --tls-san $SERVER_IP --tls-san server --disable-agent" # --flannel-iface=eth1
# curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - --bind-address ${SERVER_IP} --node-external-ip ${SERVER_IP} --tls-san $SERVER_IP --tls-san server
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - --tls-san $SERVER_IP --tls-san server

echo "**** End installing k3s"

# systemctl enable --now k3s
# systemctl start k3s
```

### Agent Provisioning script
The agent provisioning script referred to in the Vagrantfile is given below:

```shell
set -euox pipefail
sudo -i
chmod +x /dev/kvm
sed -i 's/DNSSEC=yes/DNSSEC=no/1'  /etc/systemd/resolved.conf
systemctl restart systemd-resolved.service
apt-get -y update

echo "**** Begin installing k3s"

SERVER_IP="192.168.122.10" # $(cat /vagrant/server_details/server_ip)
K3S_TOKEN=$(cat /vagrant/server_details/node-token)
K3S_URL="https://$SERVER_IP:6443"

# INSTALL_K3S_EXEC="K3S_URL=https://192.168.122.10:6443 K3S_TOKEN_FILE=/vagrant/server_details/node-token SERVER_IP=\"192.168.122.10\" "
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL=https://192.168.122.10:6443 K3S_TOKEN_FILE=/vagrant/server_details/node-token SERVER_IP=\"192.168.122.10\" sh -s -

# copying custom service file because agent install doesn't add the 
#cp /vagrant/server_details/k3s-agent.service /etc/systemd/system/k3s-agent.service
echo "**** End installing k3s"

# truncate -s -1 /etc/systemd/system/k3s-agent.service
# cat <<-EOT | tee -a /etc/systemd/system/k3s-agent.service
#     --token-file /vagrant/server_details/node-token \
#     --server https://192.168.122.10:6443
# EOT

# systemctl enable --now k3s-agent
# systemctl daemon-reload k3s-agent
# systemctl restart k3s-agent.service
````