#!/bin/bash

set -euxo pipefail

mkdir -p ./shared/server_details
# first, bring up the server
vagrant up server

sleep 10

# save server details post-provisioning for agent nodes to use
./scripts/save_server_details.sh

sleep 5

# bring up the agent
vagrant up agent1

echo "All deployed!! to use kubectl with the new cluster you can do:"
echo "$ export KUBECONFIG=`pwd`/shared/server_details/kubeconfig"
