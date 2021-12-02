# to set kubeconfig context use:
export KUBECONFIG=/home/smijar/dev/investigate/multivagrant/kubeconfig
kubectl config set-context default
kubectl get node -o wide

# Multiple VMs example
[https://akos.ma/blog/vagrant-k3s-and-virtualbox/](https://akos.ma/blog/vagrant-k3s-and-virtualbox/)

[https://www.vagrantup.com/docs/multi-machine](https://www.vagrantup.com/docs/multi-machine)

[Installing k3s](https://github.com/alexellis/k3sup#-setup-a-kubernetes-server-with-k3sup)

# Procedures
```bash
$ cat Vagrantfile
# THIS IS THERE ONLY FOR LOOP in vagrant scriipt below for multiple VMs
# - IPs did not work with libvirt
server_ip = "192.168.122.10"
agents = { "agent1" => "",
        #    "agent2" => "192.168.122.12",
        #    "agent3" => "192.168.122.13" 
    }

server_script = <<-SHELL
    sudo -i
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
    chmod +x /dev/kvm
    SHELL

agent_script = <<-SHELL
    sudo -i
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
    chmod +x /dev/kvm
    SHELL

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804" #"generic/alpine314"

  config.vm.define "server", primary: true do |server|
    config.vm.network "private_network", ip: server_ip
    # server.vm.synced_folder "./shared", "/vagrant_shared"
    # server.vm.synced_folder './', '/vagrant'#, type: 'nfs', nfs_udp: false, nfs_version: 4
    # config.vm.synced_folder "/path/on/host", "/path/on/guest", type: "sshfs"
    # config.vm.synced_folder "./", "/home/vagrant", type: "sshfs"
    config.vm.synced_folder ".", "/vagrant", type: "rsync",
      rsync__exclude: ".git/"
    server.vm.hostname = "server"
    server.vm.provider "libvirt" do |vb|
      vb.nested = true
      vb.cpu_mode = "host-passthrough"
      vb.memory = "2048"
      vb.cpus = "2"
    end
    server.vm.provision "shell", inline: server_script
  end

  agents.each do |agent_name, agent_ip|
    config.vm.define agent_name do |agent|
      # agent.vm.network "public_network", ip: agent_ip
      # agent.vm.synced_folder './', '/vagrant'#, type: 'nfs', nfs_udp: false, nfs_version: 4
      # config.vm.synced_folder "/path/on/host", "/path/on/guest", type: "sshfs"
    #   config.vm.synced_folder "./", "/home/vagrant", type: "sshfs"
      config.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: ".git/"
      agent.vm.hostname = agent_name
      agent.vm.provider "libvirt" do |vb|
        vb.nested = true
        vb.cpu_mode = "host-passthrough"
        vb.memory = "1024"
        vb.cpus = "2"
      end
      agent.vm.provision "shell", inline: agent_script
    end
  end
end
```

### Get IPs of vagrant VMs:

```bash
export SERVER1=$(vagrant ssh server -c "hostname -I" 2>/dev/null)
export AGENT1=$(vagrant ssh agent1 -c "hostname -I" 2>/dev/null)
# verify
echo $SERVER1
echo $AGENT1

$ ssh-copy-id vagrant@192.168.122.54 # server1
$ ssh-copy-id vagrant@192.168.122.80 # agent1
```

**For other VM types:**

```bash
on Linux (fedor):
$ vagrant ssh server -c "hostname -I" 2>/dev/null

on OS X:
$ vagrant ssh agent1 -c "hostname -I | cut -d' ' -f2" 2>/dev/null | pbcopy
```

# **Install K3s using K3sup**

[https://github.com/alexellis/k3sup#-setup-a-kubernetes-server-with-k3sup](https://github.com/alexellis/k3sup#-setup-a-kubernetes-server-with-k3sup)

```bash
# install server1
# $ k3sup install --user vagrant --ip $SERVER1
# $ k3sup join --user vagrant --server-ip $SERVER1 --ip $AGENT1
# $ export KUBECONFIG=/home/smijar/dev/investigate/multivagrant/kubeconfig
# $ kubectl config set-context default
# $ kubectl get node -o wide

$ k3sup install --user vagrant --ip $SERVER1
output of server
Running: k3sup install
2021/11/24 14:44:07 192.168.122.54
Public IP: 192.168.122.54
[INFO]  Finding release for channel v1.19
[INFO]  Using v1.19.16+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
Result: [INFO]  Finding release for channel v1.19
[INFO]  Using v1.19.16+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
[INFO]  systemd: Starting k3s
 Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.

Saving file to: /home/smijar/dev/investigate/multivagrant/kubeconfig

# Test your cluster with:
export KUBECONFIG=/home/smijar/dev/investigate/multivagrant/kubeconfig
kubectl config set-context default
kubectl get node -o wide

# install agent1
$ k3sup join --user vagrant --server-ip $SERVER1 --ip $AGENT1
Running: k3sup join
Server IP: 192.168.122.54
K10f685bdd7360f38b1918858e3492048b1bd0a4b8009b1efa22056d57bafa233a7::server:c46137e4e991d52f0303d3a84e90dc4b
[INFO]  Finding release for channel v1.19
[INFO]  Using v1.19.16+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
[INFO]  systemd: Starting k3s-agent
Logs: Created symlink /etc/systemd/system/multi-user.target.wants/k3s-agent.service → /etc/systemd/system/k3s-agent.service.
Output: [INFO]  Finding release for channel v1.19
[INFO]  Using v1.19.16+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.19.16+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping installation of SELinux RPM
[INFO]  Creating /usr/local/bin/kubectl symlink to k3s
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Creating /usr/local/bin/ctr symlink to k3s
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-agent-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s-agent.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s-agent.service
[INFO]  systemd: Enabling k3s-agent unit
[INFO]  systemd: Starting k3s-agent
```