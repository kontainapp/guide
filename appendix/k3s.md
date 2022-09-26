---
label: k3s multi-node cluster lab
icon: /images/k3s.png
order: 600
---

# Launching an K3S cluster

## Starting up a K3S cluster
### Pre-requisites

- Make sure docker is installed and running 

```shell
systemctl status docker
```
Output will look something like:
:::custom-shell-output
```
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-09-26 12:32:27 MST; 1h 19min ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 2208 (dockerd)
      Tasks: 38
     Memory: 178.6M
     CGroup: /system.slice/docker.service
             └─ 2208 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421464986-07:00" level=debug msg="Registering POST, /grpc"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421478846-07:00" level=debug msg="Registering GET, /networks"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421492427-07:00" level=debug msg="Registering GET, /networks/"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421505787-07:00" level=debug msg="Registering GET, /networks/{id:.+}"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421526207-07:00" level=debug msg="Registering POST, /networks/create"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421542257-07:00" level=debug msg="Registering POST, /networks/{id:.*}/connect"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421562477-07:00" level=debug msg="Registering POST, /networks/{id:.*}/disconnect"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421583447-07:00" level=debug msg="Registering POST, /networks/prune"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421599597-07:00" level=debug msg="Registering DELETE, /networks/{id:.*}"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421807158-07:00" level=info msg="API listen on /run/docker.sock"

```
:::

- Add your user to Docker group to avoid typing sudo everytime you run docker commands.

```shell
sudo usermod -aG docker ${USER}
newgrp docker
```
### Create cluster using Kontain helper script

Download helper script, make sure it is executable and run it

```shell
curl -o k3s-cluster.sh https://raw.githubusercontent.com/kontainapp/k8s-deploy/master/helpers/k3s-cluster.sh
chmod +x k3s-cluster.sh
./k3s-cluster.sh
```

Setup kubectl config file
```shell
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
### Verify your cluster was created

First, make sure k3s is running
```shell
systemctl status k3s
```
The output will look like 
:::custom-shell-output
```
● k3s.service - Lightweight Kubernetes
     Loaded: loaded (/etc/systemd/system/k3s.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-09-26 14:00:25 MST; 3min 11s ago
       Docs: https://k3s.io
    Process: 16675 ExecStartPre=/bin/sh -xc ! /usr/bin/systemctl is-enabled --quiet nm-cloud-setup.service (code=exited, status=0/SUCCESS)
    Process: 16677 ExecStartPre=/sbin/modprobe br_netfilter (code=exited, status=0/SUCCESS)
    Process: 16678 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 16679 (k3s-server)
      Tasks: 183
     Memory: 870.2M
     CGroup: /system.slice/k3s.service
             ├─ 16679 "/usr/local/bin/k3s server"
             ├─ 16738 containerd -c /var/lib/rancher/k3s/agent/etc/containerd/config.toml -a /run/k3s/containerd/containerd.sock --state /run/k3s/containerd --root>
             ├─ 32748 /var/lib/rancher/k3s/data/1d787a9b6122e3e3b24afe621daa97f895d85f2cb9cc66860ea5ff973b5c78f2/bin/containerd-shim-runc-v2 -namespace k8s.io -id >
             ├─ 32775 /var/lib/rancher/k3s/data/1d787a9b6122e3e3b24afe621daa97f895d85f2cb9cc66860ea5ff973b5c78f2/bin/containerd-shim-runc-v2 -namespace k8s.io -id >
             └─ 32802 /var/lib/rancher/k3s/data/1d787a9b6122e3e3b24afe621daa97f895d85f2cb9cc66860ea5ff973b5c78f2/bin/containerd-shim-runc-v2 -namespace k8s.io -id >
```
:::

Now, we will check that master node is running

```
kubectl get nodes
```
The output looks like 
:::custom-shell-output
```
NAME        STATUS   ROLES                  AGE     VERSION
my-comp     Ready    control-plane,master   4m41s   v1.24.3+k3s1
```
:::

### Add worker nodes ( skip if single node cluster is sufficient)
- Allow ports on firewall
for Ubuntu
```
sudo ufw allow 6443/tcp
sudo ufw allow 443/tcp
```
for Fedora or Centos
```
sudo firewall-cmd --add-port=443/tcp
sudo firewall-cmd --add-port=6443/tcp
```

- On the master node:

```shell
sudo cat /var/lib/rancher/k3s/server/node-token
```
You will then obtain a token that looks like:

:::custom-shell-output
```
K1078f2861628c95aa328595484e77f831adc3b58041e9ba9a8b2373926c8b034a3::server:417a7c6f46330b601954d0aaaa1d0f5b
```
:::

- On worker node 
First,make sure docker is running
```shell
systemctl status docker
```
Output will look something like:
:::custom-shell-output
```
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-09-26 12:32:27 MST; 1h 19min ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 2208 (dockerd)
      Tasks: 38
     Memory: 178.6M
     CGroup: /system.slice/docker.service
             └─ 2208 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421464986-07:00" level=debug msg="Registering POST, /grpc"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421478846-07:00" level=debug msg="Registering GET, /networks"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421492427-07:00" level=debug msg="Registering GET, /networks/"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421505787-07:00" level=debug msg="Registering GET, /networks/{id:.+}"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421526207-07:00" level=debug msg="Registering POST, /networks/create"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421542257-07:00" level=debug msg="Registering POST, /networks/{id:.*}/connect"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421562477-07:00" level=debug msg="Registering POST, /networks/{id:.*}/disconnect"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421583447-07:00" level=debug msg="Registering POST, /networks/prune"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421599597-07:00" level=debug msg="Registering DELETE, /networks/{id:.*}"
Sep 26 12:32:27 fc dockerd[2208]: time="2022-09-26T12:32:27.421807158-07:00" level=info msg="API listen on /run/docker.sock"

```
:::

Install k3s agent

```shell
curl -sfL http://get.k3s.io | K3S_URL=https://<master_IP>:6443 K3S_TOKEN=<join_token> sh -s - --docker
```

and check that agent is running

```shell
systemctl status k3s-agent
```
The output will look like 
:::custom-shell-output
```
● k3s-agent.service - Lightweight Kubernetes
     Loaded: loaded (/etc/systemd/system/k3s-agent.service; enabled; vendor preset: disabled)
     Active: active (running) since Mon 2022-09-26 14:26:51 MST; 9s ago
       Docs: https://k3s.io
    Process: 23437 ExecStartPre=/bin/sh -xc ! /usr/bin/systemctl is-enabled --quiet nm-cloud-setup.service (code=exited, status=0/SUCCESS)
    Process: 23439 ExecStartPre=/sbin/modprobe br_netfilter (code=exited, status=0/SUCCESS)
    Process: 23440 ExecStartPre=/sbin/modprobe overlay (code=exited, status=0/SUCCESS)
   Main PID: 23441 (k3s-agent)
      Tasks: 19
     Memory: 39.2M
        CPU: 1.086s
     CGroup: /system.slice/k3s-agent.service
             └─ 23441 "/usr/local/bin/k3s agent"

Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.098089   23441 kube.go:128] Node controller sync successful
Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.167886   23441 kube.go:357] Skip setting NodeNetworkUnavailable
Sep 26 14:26:52 serge-laptop k3s[23441]: time="2022-09-26T14:26:52-07:00" level=info msg="Wrote flannel subnet file to /run/flannel/subnet.env"
Sep 26 14:26:52 serge-laptop k3s[23441]: time="2022-09-26T14:26:52-07:00" level=info msg="Running flannel backend."
Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.172324   23441 route_network.go:55] Watching for new subnet leases
Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.172422   23441 route_network.go:92] Subnet added: 10.42.0.0/24 via 10.100.101.101
Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.195126   23441 iptables.go:177] bootstrap done
Sep 26 14:26:52 serge-laptop k3s[23441]: I0926 14:26:52.199374   23441 iptables.go:177] bootstrap done
Sep 26 14:26:55 serge-laptop k3s[23441]: time="2022-09-26T14:26:55-07:00" level=info msg="Using CNI configuration file /var/lib/rancher/k3s/agent/etc/cni/net.d/10-flannel.co>
Sep 26 14:27:00 serge-laptop k3s[23441]: time="2022-09-26T14:27:00-07:00" level=info msg="Using CNI configuration file /var/lib/rancher/k3s/agent/etc/cni/net.d/10-flannel.co>
```
:::

- On master node use kubectl to see both master and worker nodes
```
kubectl get nodes
```

Output will look like 

The output will look like the following.
:::custom-shell-output
```
NAME        STATUS   ROLES                  AGE     VERSION
my-comp     Ready    control-plane,master   4m41s   v1.24.3+k3s1
worker      Ready    <none>                 28s     v1.24.4+k3s1
```
:::

Repeat this process to add more worker nodes

## Enable and Test Kontain Runtime
Please refer to: [Install Kontain in Kubernetes](/getting_started/kubenetes/)
## Clean up
- On each worker node
```
sudo /usr/local/bin/k3s-agent-uninstall.sh
sudo rm -rf /var/lib/rancher
```

- On master node
```shell
k3s-cluster.sh  --cleanup
```
