#!/bin/bash

set -euxo pipefail

# first, bring up the server
vagrant up server

sleep 10

# save server details post-provisioning for agent nodes to use
./scripts/save_server_details.sh

sleep 5

# bring up the agent
vagrant up agent1

echo "All deployed!! to leverage the new cluster you can do one of the following:"
echo "you do $ export KUBECONFIG=./shared/server_details/kubeconfig"