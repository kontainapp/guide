---
label: Starting Azure AKS Cluster
icon: /images/aks.png
order: 890
---

# Launching an AKS cluster
Below we describe how we can launch and use Kontain in an Azure AKS (Kubernetes) cluster.

## Starting up an AKS cluster

### Pre-requisites
- [Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)  Azure CLI,  
- Create an Azure AKS account 
- Verify that you are able to use the Azure CLI to  [login](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to AKS:

```shell
az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>
```
or
```shell
az login -u <username> -p <password>
```
and, only once, set your subscription to ensure that you are using the right one for your cluster
```shell
az account set --subscription "<your-subscription-id>"
```

Note: Follow instructions in [Sign in with Azure CLI](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) if you have any issues or questions

### Create cluster using Kontain helper script

Download helper script and make sure it is executable

```shell
curl -o aks-cluster.sh https://raw.githubusercontent.com/kontainapp/k8s-deploy/master/helpers/aks-cluster.sh
chmod +x aks-cluster.sh
```

Run script using your credential. Make sure to set region and prefix to your desired values.  The script will create AKS cluster with the name <prefix>-aks-cluster. All other associated recource names are prefixed with <prefix> 

```shell
aks-cluster.sh  --tenant=TENANT_ID --app-id=AZURE_APP_ID --password=AZURE_SECRET --region=<your region> <prefix>
```

### Verify your cluster was created
```shell
az aks list -o table
```
## Enable and Test Kontain Runtime
Please refer to: [Install Kontain in Kubernetes](/getting_started/kubenetes/)
## Clean up
```shell
aks-cluster.sh  --tenant=TENANT_ID --app-id=AZURE_APP_ID --password=AZURE_SECRET --region=<your region> <prefix> --cleanup
```