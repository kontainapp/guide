#!/bin/bash
#set -e; [ "$TRACE" ] && set -x
set -e
set -x

# figure out the latest release
# This script must be run as root.
[ `id -u` != "0" ] && echo "Must run as root" && exit 1

source /etc/os-release
[ "$ID" != "fedora" -a "$ID" != "ubuntu" -a "$ID" != "amzn" ] && echo "Unsupported linux distribution: $ID" && exit 1

TAG=${1:-$(curl -L -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/current_release.txt)}
if [[ $TAG = latest ]] ; then
   readonly URL="https://github.com/kontainapp/km/releases/${TAG}/download/kontain.tar.gz"
   readonly URL_BIN="https://github.com/kontainapp/km/releases/${TAG}/download/kontain_bin.tar.gz"
else
   readonly URL="https://github.com/kontainapp/km/releases/download/${TAG}/kontain.tar.gz"
   readonly URL_BIN="https://github.com/kontainapp/km/releases/download/${TAG}/kontain_bin.tar.gz"
fi
readonly PREFIX="/opt/kontain"

# install yum-utils which contains needs-restarting to check if a reboot is necessary after update
sudo dnf install -y dnf-utils wget jq git
# install kernel-devel for current package
sudo dnf install -y "kernel-devel-uname-r == $(uname -r)"
# update without updating kernel (IMPORTANT FOR KKM)
sudo dnf -y --exclude=kernel* update

# check if it needs rebooting while yum not running
# ensure that cloud-init runs again after reboot by removing the instance record created
(test ! -f /var/cache/dnf/*pid && needs-restarting -r) || (rm -rf /var/lib/cloud/instances/;reboot)

# install Kontain with KKM
mkdir -p /tmp/kontain
cd /tmp/kontain
wget $URL_BIN
tar xvzf kontain_bin.tar.gz

# move files into /opt/kontain
mkdir -p /opt/kontain/bin; chown root /opt/kontain
mv container-runtime/krun /opt/kontain/bin/krun
mv km/km /opt/kontain/bin/

# install KKM
./kkm.run

# install docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker

# and include fedora in docker group
usermod -a -G docker fedora
# usermod -a -G docker ${USER}
# newgrp docker

# install docker-compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod -v +x /usr/local/bin/docker-compose

mkdir -p /etc/docker/
cat <<EOF >> /etc/docker/daemon.json
{
    "runtimes": {
        "krun": {
            "path": "/opt/kontain/bin/krun"
        }
    }
}
EOF

# start docker without blocking since cloud-init can cause deadlock issues
systemctl restart --no-block docker

# -----------------------------------
# install Kontain main release
curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash

# installing JDK
sudo dnf install -y java-11-openjdk.x86_64
dnf module -y install nodejs:12

# install golang
dnf -y install go
mkdir -p /home/fedora/go/src

# add golang path
cat <<EOF >> /home/fedora/.bash_profile
export GOPATH='/home/feodra/go'
export PATH="$PATH:/usr/local/go/bin"
EOF

#install minikube so we have kubernetes testing
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
