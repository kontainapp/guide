URL_KONTAIN_BIN="https://github.com/kontainapp/km/releases/latest/download/kontain_bin.tar.gz"

# install packages
yum install -y jq wget

# prep tmp folder for download
mkdir /tmp/kontain
cd /tmp/kontain

# download and move files into place
cd /tmp/kontain
wget $URL_KONTAIN_BIN
tar xvzf kontain_bin.tar.gz

# move files into /opt/kontain
mkdir -p /opt/kontain/bin; chown root /opt/kontain
mv container-runtime/krun /opt/kontain/bin/
mv km/km /opt/kontain/bin/
mv bin/docker_config.sh /opt/kontain/bin/

# install KKM
./kkm.run

# configure and restart docker with Kontain as runtime
# systemctl restart --no-block docker
bash /opt/kontain/bin/docker_config.sh