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