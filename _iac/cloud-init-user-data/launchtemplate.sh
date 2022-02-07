#!/bin/bash
yum update -y

# install docker
amazon-linux-extras install docker
systemctl enable docker
systemctl start --no-block docker

# and include ec2-user in docker group
usermod -a -G docker ec2-user
newgrp docker

# install docker-compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
chmod -v +x /usr/local/bin/docker-compose

# install utils
cd /tmp
yum install -y jq

# download and install kontain
mkdir /tmp/kontain
cd /tmp/kontain
curl -o kkm.run -L  https://github.com/kontainapp/km/releases/download/v0.9.5/kkm.run
chmod +x ./kkm.run && ./kkm.run
mkdir -p /opt/kontain ; chown root /opt/kontain
curl -s https://raw.githubusercontent.com/kontainapp/km/current/km-releases/kontain-install.sh | sudo bash

# Now, install static krun
curl -o kontain_bin.tar.gz -L  https://github.com/kontainapp/km/releases/download/v0.9.5/kontain_bin.tar.gz
tar xvzf kontain_bin.tar.gz
cp container-runtime/krun /opt/kontain/bin/