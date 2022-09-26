---
label: Starting Amazon EKS Cluster
icon: /images/eks.png
order: 890
---

# Launching an EKS cluster
Below we describe how we can launch and use Kontain in an Amazon EKS (Kubernetes) cluster.

## Starting up an EKS cluster

### Pre-requisites
- Follow step outlines in [Getting started with the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) to setup your CLI. 
- [Set up your credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html). Create two environment variables from the values you created

```shell
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX
export AWS_ACCESS_KEY_ID=XXXXXXXXXXX
```

### Create cluster using Kontain helper script

Download helper script and make sure it is executable

```shell
curl -o eks-cluster.sh https://raw.githubusercontent.com/kontainapp/k8s-deploy/master/helpers/eks-cluster.sh
chmod +x eks-cluster.sh
```

Run script using your credential. Make sure to set region and prefix to your desired values.  The script will create AKS cluster with the name <prefix>-eks-cluster. All other associated recource names are prefixed with <prefix> 

```shell
eks-cluster.sh  --region=<your region> --ami=<Kontain-enabled AMI id> <prefix>
```

To locate Kontain-enabled ami run use the following coman:

```shell
aws ec2 describe-images --region=us-west-1 --filters "Name=name,Values=kontain-ecs-node*" |jq -r '.Images[] | "AMI-Id: \(.ImageId), Name: \(.Name)"'
```

and select the version you want. 

At this moment, Kontain provides images only in us-west-1. If you woudl like to use it in another region [copy AMI to your region](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/CopyingAMIs.html) first. Then use newly created AMI-ID


### Verify your cluster was created
```shell
aws eks list-clusters --region=<your region>
```
## Enable and Test Kontain Runtime
Please refer to: [Install Kontain in Kubernetes](/getting_started/kubenetes/)
## Clean up
```shell
eks-cluster.sh  --region=<your region> <prefix> --cleanup
```