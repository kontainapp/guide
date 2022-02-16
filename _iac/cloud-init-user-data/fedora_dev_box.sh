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

sudo dnf install -y dnf-utils wget jq git
sudo dnf update -y

# check if it needs rebooting while yum not running
# ensure that cloud-init runs again after reboot by removing the instance record created
(test ! -f /var/cache/dnf/*pid && needs-restarting -r) || (rm -rf /var/lib/cloud/instances/;reboot)

# install Kontain with KKM
mkdir /tmp/kontain
cd /tmp/kontain
wget $URL_BIN
tar xvzf kontain_bin.tar.gz

# move files into /opt/kontain
mkdir -p /opt/kontain/bin; chown root /opt/kontain
mv container-runtime/krun-label-trigger /opt/kontain/bin/krun
mv km/km /opt/kontain/bin/
mv bin/docker_config.sh /opt/kontain/bin/

# install KKM
./kkm.run

# install docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io

systemctl enable docker

usermod -a -G docker fedora
newgrp docker

# install docker-compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod -v +x /usr/local/bin/docker-compose

# systemctl restart --no-block docker
#!/bin/bash
cat <<EOF >> /etc/docker/daemon.json
{
    "runtimes": {
        "krun": {
            "path": "/opt/kontain/bin/krun"
        },
        "runsc": {
            "path": "/usr/local/bin/runsc"
        }
}
EOF

systemctl restart --no-block docker

# install Kontain main release
curl -s $URL | sudo bash
