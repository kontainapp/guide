---
label: Azure AKS
icon: /images/aks.png
order: 700
---

# Using Kontain in AKS
Below we describe how we can launch and use Kontain in an Azure AKS (Kubernetes) cluster.

##### Starting up an AKS cluster

+++ Login to Azure
Here, we assume that you have Azure CLI [installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) have an Azure AKS account and are able to use the Azure CLI to be able to [login](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to AKS using either:

```shell
# launches a browser for logging in with your credentials
$ az login
# or
$ az login -u <username> -p <password>
# or (if you don't have a browser - use this URL https://aka.ms/devicelogin)
$ az login --use-device-code

# and, only once, set your subscription to ensure that you are using the right one for your cluster
$ az account set --subscription "<your-subscription-id>"

```
Note: This approach may not work with Microsoft accounts or accounts that have two-factor authentication enabled.

+++ Start a Kubernetes (AKS) cluster
Below is an example of starting a kubernetes cluster in US-West region 1.

We use an instance that enables use of "Nested" Virutalization using KVM, and in case of Azure, the minimum instance that enables this is "Standard_D4s_v3".

```
# create a resource using which you can dispose of your cluster later
az group create --name kdocs --location westus2

# create a 1 node cluster for testing with an instance that enables nested virutalization using KVM
az aks create \
-g kdocs \
-n kdocscluster \
--enable-managed-identity \
--node-count 1 \
--generate-ssh-keys \
--node-vm-size Standard_D4s_v3 \
--node-vm-size Standard_D4s_v3
# --network-policy calico
# --network-plugin kubenet
# --enable-addons monitoring

# takes a little time to start

# if you want to add a node with nested virtualization turned on, add custom node
$ az aks nodepool add \
--resource-group kdocs \
--cluster-name kdocscluster \
--name nested \
--node-vm-size Standard_D4s_v3 \
--labels nested=true \
--node-count 1

# list your current clusters
$ az aks list -o table

# To access this cluster using kubectl
$ az aks get-credentials --resource-group kdocs --name kdocscluster

# check the nodes
$ kubectl get nodes -o wide


# after using it
# to delete the nodepool
$ az aks nodepool delete --resource-group kdocs --cluster-name kdocscluster --name nested

# to delete cluster
$ az group delete --name kdocs --yes #--no-wait
```

+++ Installing Kontain in Azure AKS
You can follow instructions from [here](/guide/getting_started/install/#on-minikube-or-managed-or-regular-kubernetes) to use Kontain in Azure AKS.