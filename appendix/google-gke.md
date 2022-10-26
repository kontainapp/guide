---
label: Starting Google GKE Cluster
icon: /images/gke.png
order: 890
---

# Launching an GKE cluster
Below we describe how we can launch and use Kontain in a Google GKE (Kubernetes) cluster.

## Starting up an GKE cluster

### Pre-requisites
Take the following steps to enable the Kubernetes Engine API:
- [Sign in to your Google Cloud account](https://console.cloud.google.com/freetrial?_ga=2.49271654.1392909812.1664219973-2131462911.1664219973). If you're new to Google Cloud, [create an account](https://console.cloud.google.com/freetrial?_ga=2.49271654.1392909812.1664219973-2131462911.1664219973) to evaluate how our products perform in real-world scenarios. 

- In the Google Cloud console, on the project selector page, select or [create a Google Cloud project](https://cloud.google.com/resource-manager/docs/creating-managing-projects).

!!!
Note: If you don't plan to keep the resources that you create in this procedure, create a new project instead of selecting an existing one. After you finish these steps, you can delete the project, removing all resources associated with it.
!!!

- [Go to project selector](https://console.cloud.google.com/projectselector2/home/dashboard)

- Make sure that billing is enabled for your Cloud project. Learn how to [check if billing is enabled on a project](https://cloud.google.com/billing/docs/how-to/verify-billing-enabled).
- [Enable the Artifact Registry and Google Kubernetes Engine APIs](https://console.cloud.google.com/flows/enableapi?apiid=artifactregistry.googleapis.com,container.googleapis.com).

- [Install Kubectl auth plugin](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke)

- [Installing](https://cloud.google.com/sdk/docs/install) and [Initializing](https://cloud.google.com/sdk/docs/initializing) gcloud CLI

### Create cluster using Kontain helper script

Download helper script and make sure it is executable

```shell
curl -o gce-cluster.sh https://raw.githubusercontent.com/kontainapp/k8s-deploy/master/helpers/gce-cluster.sh
chmod +x gce-cluster.sh
```

Run script using your credentials. Make sure to set region and prefix to your desired values.  The script will create AKS cluster with the name \<prefix\>-gce-cluster. All other associated recource names are prefixed with \<prefix\>. 

```shell
gce-cluster.sh  --project=<you rproject id> <prefix>
```

### Verify your cluster was created
```shell
gcloud container clusters list
```

## Enable and Test Kontain Runtime
Please refer to: [Install Kontain in Kubernetes](/getting_started/kubenetes/)
## Clean up
To delete cluster and all associated resources use the following
```shell
gce-cluster.sh  <prefix> --cleanup
```
