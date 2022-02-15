#!/bin/bash
#set -e; [ "$TRACE" ] && set -x
set -e
set -x

# figure out the latest release
# This script must be run as root.
[ `id -u` != "0" ] && echo "Must run as root" && exit 1

source /etc/os-release
[ "$ID" != "fedora" -a "$ID" != "ubuntu" -a "$ID" != "amzn" ] && echo "Unsupported linux distribution: $ID" && exit 1

#TAG=${1:-$(curl -L -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/current_release.txt)}
# forcing it to be latest
TAG='latest'
if [[ $TAG = latest ]] ; then
   readonly URL_KONTAIN_TAR_GZ="https://github.com/kontainapp/km/releases/${TAG}/download/kontain.tar.gz"
   readonly URL_KONTAIN_BIN="https://guide-assets.s3.us-west-2.amazonaws.com/downloads/kontain_bin.tar.gz"
else
   readonly URL_KONTAIN_TAR_GZ="https://github.com/kontainapp/km/releases/download/${TAG}/kontain.tar.gz"
   readonly URL_KONTAIN_BIN="https://guide-assets.s3.us-west-2.amazonaws.com/downloads/kontain_bin.tar.gz"
fi
readonly PREFIX="/opt/kontain"


# install yum-utils which contains needs-restarting to check if a reboot is necessary after update
yum install -y yum-utils
yum update -y

# check if it needs rebooting while yum not running
# ensure that cloud-init runs again after reboot by removing the instance record created
(test ! -f /var/run/yum.pid && needs-restarting -r) || (rm -rf /var/lib/cloud/instances/;reboot)

# install Kontain with KKM
mkdir /tmp/kontain
cd /tmp/kontain
wget $URL_KONTAIN_BIN
tar xvzf kontain_bin.tar.gz

# move files into /opt/kontain
mkdir -p /opt/kontain/bin; chown root /opt/kontain
mv container-runtime/krun-label-trigger /opt/kontain/bin/krun
mv km/km /opt/kontain/bin/
mv bin/docker_config.sh /opt/kontain/bin/

# install KKM
./kkm.run

# install docker
amazon-linux-extras disable docker
amazon-linux-extras install -y ecs
systemctl enable docker
# systemctl enable --now docker
# start/restart at the end

# and include ec2-user in docker group
usermod -a -G docker ec2-user
newgrp docker

# install docker-compose
#wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
#mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
#chmod -v +x /usr/local/bin/docker-compose

# systemctl restart --no-block docker
yum install -y wget jq
bash /opt/kontain/bin/docker_config.sh

# configure ecs cluster
cat<<EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=ecstestclstr3
EOF

# configures and restart docker and ecs agent
systemctl restart --no-block docker
systemctl restart --no-block ecs