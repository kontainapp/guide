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
