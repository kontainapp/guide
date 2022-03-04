# ref
## kind
https://kind.sigs.k8s.io/docs/user/quick-start/

## k3d
https://k3d.io/v5.3.0/#quick-start
set up k3d on AWS with security groups: https://github.com/cnrancher/autok3s/blob/master/docs/i18n/en_us/aws/README.md
autok3s with UI/CLI to deploy k3s anywhere: https://github.com/cnrancher/autok3s

# k3s
https://rancher.com/docs/k3s/latest/en/quick-start/

# testing on multi-versions of kubernetes
https://gist.github.com/alexchiri/5791c93eaf31f53ad865336fa09527ba

If for example, we want to create a kind cluster that uses Kubernetes 1.17.5 using the kind config above, we would run:
```shell
$ kind create cluster --image "kindest/node:v1.17.5" --name kind-cluster --config kind-config.yaml
```


## AKS
instance type(nested): https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series#dsv3-series

Nested cluster:
https://medium.com/cooking-with-azure/using-kubevirt-in-azure-kubernetes-service-part-2-178396939aee

# multi-node
kind:
https://mcvidanagama.medium.com/set-up-a-multi-node-kubernetes-cluster-locally-using-kind-eafd46dd63e5

k3s:
https://k3d.io/v5.1.0/usage/multiserver/

# minikube
https://minikube.sigs.k8s.io/docs/start/

## EKS
https://eksctl.io/usage/container-runtime/
FULL DELETE CLI: https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/delete-cluster.md

### if creating 2nd node group use nodeselectors like below
https://multinode-kubernetes-cluster.readthedocs.io/en/latest/08-k8s-daemonsets.html

https://eksctl.io/usage/managing-nodegroups/#deleting-and-draining

```shell
# create
$ eksctl create cluster -f ./aws/kdocscluster-eks-2.yaml

# POST-CREATION - add nodegroup by adding to above cluster file
$ eksctl create nodegroup --config-file=./aws/kdocscluster-eks-2.yaml

# if deleting nodegroup:
eksctl delete nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --disable-eviction

# if scaling down to delete the node from the nodegroup:
eksctl scale nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --nodes=0

$ cat aws/kdocscluster-eks-2.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: kdocscluster-eks-2
  region: us-west-2

nodeGroups:
  - name: kdocscluster-eks-2-ng-1
    instanceType: m5.xlarge
    desiredCapacity: 1
    amiFamily: AmazonLinux2
```



### output
```shell
# output of create cluster
2022-03-01 07:39:33 [ℹ]  eksctl version 0.85.0
2022-03-01 07:39:33 [ℹ]  using region us-west-2
2022-03-01 07:39:34 [ℹ]  setting availability zones to [us-west-2b us-west-2c us-west-2d]
2022-03-01 07:39:34 [ℹ]  subnets for us-west-2b - public:192.168.0.0/19 private:192.168.96.0/19
2022-03-01 07:39:34 [ℹ]  subnets for us-west-2c - public:192.168.32.0/19 private:192.168.128.0/19
2022-03-01 07:39:34 [ℹ]  subnets for us-west-2d - public:192.168.64.0/19 private:192.168.160.0/19
2022-03-01 07:39:34 [ℹ]  nodegroup "kdocscluster-eks-2-ng-1" will use "ami-0f4e332ce13a3ea14" [AmazonLinux2/1.21]
2022-03-01 07:39:34 [ℹ]  using Kubernetes version 1.21
2022-03-01 07:39:34 [ℹ]  creating EKS cluster "kdocscluster-eks-2" in "us-west-2" region with un-managed nodes
2022-03-01 07:39:34 [ℹ]  1 nodegroup (kdocscluster-eks-2-ng-1) was included (based on the include/exclude rules)
2022-03-01 07:39:34 [ℹ]  will create a CloudFormation stack for cluster itself and 1 nodegroup stack(s)
2022-03-01 07:39:34 [ℹ]  will create a CloudFormation stack for cluster itself and 0 managed nodegroup stack(s)
2022-03-01 07:39:34 [ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=us-west-2 --cluster=kdocscluster-eks-2'
2022-03-01 07:39:34 [ℹ]  Kubernetes API endpoint access will use default of {publicAccess=true, privateAccess=false} for cluster "kdocscluster-eks-2" in "us-west-2"
2022-03-01 07:39:34 [ℹ]  CloudWatch logging will not be enabled for cluster "kdocscluster-eks-2" in "us-west-2"
2022-03-01 07:39:34 [ℹ]  you can enable it with 'eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=us-west-2 --cluster=kdocscluster-eks-2'
2022-03-01 07:39:34 [ℹ]
2 sequential tasks: { create cluster control plane "kdocscluster-eks-2",
    2 sequential sub-tasks: {
        wait for control plane to become ready,
        create nodegroup "kdocscluster-eks-2-ng-1",
    }
}
2022-03-01 07:39:34 [ℹ]  building cluster stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:39:34 [ℹ]  deploying stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:40:04 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:40:35 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:41:35 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:42:35 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:43:35 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:44:35 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:45:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:46:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:47:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:48:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:49:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:50:37 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-cluster"
2022-03-01 07:52:38 [ℹ]  building nodegroup stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:52:38 [ℹ]  --nodes-min=1 was set automatically for nodegroup kdocscluster-eks-2-ng-1
2022-03-01 07:52:38 [ℹ]  --nodes-max=1 was set automatically for nodegroup kdocscluster-eks-2-ng-1
2022-03-01 07:52:39 [ℹ]  deploying stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:52:39 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:52:56 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:53:13 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:53:28 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:53:44 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:54:00 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:54:19 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:54:36 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:54:55 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:55:11 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:55:26 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:55:42 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:56:01 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1"
2022-03-01 07:56:01 [ℹ]  waiting for the control plane availability...
2022-03-01 07:56:01 [✔]  saved kubeconfig as "/home/smijar/.kube/config"
2022-03-01 07:56:01 [ℹ]  no tasks
2022-03-01 07:56:01 [✔]  all EKS cluster resources for "kdocscluster-eks-2" have been created
2022-03-01 07:56:01 [ℹ]  adding identity "arn:aws:iam::782340374253:role/eksctl-kdocscluster-eks-2-nodegro-NodeInstanceRole-8SWKK9LOE9FK" to auth ConfigMap
2022-03-01 07:56:01 [ℹ]  nodegroup "kdocscluster-eks-2-ng-1" has 0 node(s)
2022-03-01 07:56:01 [ℹ]  waiting for at least 1 node(s) to become ready in "kdocscluster-eks-2-ng-1"
2022-03-01 07:56:37 [ℹ]  nodegroup "kdocscluster-eks-2-ng-1" has 1 node(s)
2022-03-01 07:56:37 [ℹ]  node "ip-192-168-27-215.us-west-2.compute.internal" is ready
2022-03-01 07:56:39 [ℹ]  kubectl command should work with "/home/smijar/.kube/config", try 'kubectl get nodes'
2022-03-01 07:56:39 [✔]  EKS cluster "kdocscluster-eks-2" in "us-west-2" region is ready
```

```
# output of create nodegroup 2
2022-03-01 09:45:59 [ℹ]  eksctl version 0.85.0
2022-03-01 09:45:59 [ℹ]  using region us-west-2
2022-03-01 09:45:59 [ℹ]  will use version 1.21 for new nodegroup(s) based on control plane version
2022-03-01 09:46:01 [ℹ]  nodegroup "kdocscluster-eks-2-ng-1" will use "ami-07b6ddb2869aacd51" [AmazonLinux2/1.21]
2022-03-01 09:46:01 [ℹ]  using SSH public key "/home/smijar/.ssh/id_rsa.pub" as "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-1-6e:e3:e0:56:73:1b:e1:13:1a:67:fa:6a:c8:80:93:6f"
2022-03-01 09:46:01 [ℹ]  nodegroup "kdocscluster-eks-2-ng-2" will use "ami-07b6ddb2869aacd51" [AmazonLinux2/1.21]
2022-03-01 09:46:01 [ℹ]  using SSH public key "/home/smijar/.ssh/id_rsa.pub" as "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2-6e:e3:e0:56:73:1b:e1:13:1a:67:fa:6a:c8:80:93:6f"
2022-03-01 09:46:02 [ℹ]  1 existing nodegroup(s) (kdocscluster-eks-2-ng-1) will be excluded
2022-03-01 09:46:02 [ℹ]  1 nodegroup (kdocscluster-eks-2-ng-2) was included (based on the include/exclude rules)
2022-03-01 09:46:02 [ℹ]  will create a CloudFormation stack for each of 1 nodegroups in cluster "kdocscluster-eks-2"
2022-03-01 09:46:02 [ℹ]
2 sequential tasks: { fix cluster compatibility, 1 task: { 1 task: { create nodegroup "kdocscluster-eks-2-ng-2" } }
}
2022-03-01 09:46:02 [ℹ]  checking cluster stack for missing resources
2022-03-01 09:46:03 [ℹ]  cluster stack has all required resources
2022-03-01 09:46:03 [ℹ]  building nodegroup stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:46:03 [ℹ]  --nodes-min=2 was set automatically for nodegroup kdocscluster-eks-2-ng-2
2022-03-01 09:46:03 [ℹ]  --nodes-max=2 was set automatically for nodegroup kdocscluster-eks-2-ng-2
2022-03-01 09:46:03 [ℹ]  deploying stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:46:03 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:46:23 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:46:43 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:47:02 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
2022-03-01 09:47:18 [ℹ]  waiting for CloudFormation stack "eksctl-kdocscluster-eks-2-nodegroup-kdocscluster-eks-2-ng-2"
```