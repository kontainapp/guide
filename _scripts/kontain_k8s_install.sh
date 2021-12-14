#!/usr/bin/sh
set -euxo pipefail

# install the config maps
kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/v0.9.2/cloud/k8s/deploy/runtime-class.yaml
kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/v0.9.2/cloud/k8s/deploy/cm-install-lib.yaml
kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/v0.9.2/cloud/k8s/deploy/cm-containerd-install.yaml

# deploy the runtime using kustomize
kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/sm/v0.9.2/cloud/k8s/deploy/kontain-deploy/base/kontain-deploy.yaml
