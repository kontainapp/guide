SHELL :=/bin/bash

all: build_overlays kind aks gke minikube-crio
.PHONY: all

# exports all vars
.EXPORT_ALL_VARIABLES:

# used when wanting to rsync (. hidden) files
#SHELL := bash -O dotglob or extglob
SHELL := /bin/bash

# include environment variables file
ifneq (,$(wildcard ./.env))
    include  .env
    export
endif

build-overlays:
	mkdir -p ./outputs/

	echo "building overlays"
	# to apply directly, use:
	# 	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/base?ref=sm/k8sversionupdate" | kubectl apply -f -
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/base?ref=sm/k8sversionupdate" > ./kustomize_outputs/km.yaml
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/overlays/km-crio?ref=sm/k8sversionupdate" > ./kustomize_outputs/km-crio.yaml
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/overlays/kkm?ref=sm/k8sversionupdate" > ./kustomize_outputs/kkm.yaml
	/usr/local/bin/kustomize build "https://github.com/kontainapp/km//cloud/k8s/deploy/kontain-deploy/overlays/k3s?ref=sm/k8sversionupdate" > ./kustomize_outputs/k3s.yaml

kindcluster:
	echo "creating kind cluster: kind-kind"
	kind create cluster --wait 5m
	- kubectl config set-context "kind-kind"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces
	sleep 10

kindcluster-apply-km:
	echo "applying km to kind cluster: kind-kind"
	# kubectl apply -f outputs/km.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/km.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-kind.log

	sleep 5

kindcluster-apply-kkm:
	echo "applying kkm to kind cluster: kind-kind"
	# kubectl apply -f outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/kkm.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer.log

	sleep 5

kindcluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kind-kind"

	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

kindcluster-clean:
	echo "deleting kind cluster: kind-kind"
	- kubectl config delete-context "kind-kind"
	kind delete cluster

#-----------------
k3dcluster:
	echo "creating k3d cluster: k3d" 
	k3d cluster create --config conf/k3d/config.yml --k3s-arg "--no-deploy=traefik@server:*" --wait
	- kubectl config set-context "k3d"
	kubectl config current-context
	sleep 30
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=120s

k3dcluster-apply-km:
	echo "applying km to kind cluster: k3d"
	# kubectl apply -f outputs/km.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/k3s.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-k3d.log

	sleep 5


k3dcluster-clean:
	echo "deleting k3d cluster: k3s"
	- kubectl config delete-context "k3d"
	k3d cluster delete k3d


#------------------
minikubecluster:
	echo "creating minikube cluster: minikube"
	minikube start --container-runtime=containerd --driver=docker --wait=all
	- kubectl config set-context minikube
	kubectl config current-context

minikubecluster-clean:
	echo "deleting k3d cluster: minikube"
	- kubectl config delete-context minikube
	minikube delete
	k3d cluster delete

#------------------
akscluster:
	echo "setting up 1-node AKS cluster - kdocscluster-aks - using Dsv3 instance type"
	# az aks create -g kdocs -n "kdocscluster-aks" --enable-managed-identity --node-count 1 --generate-ssh-keys --node-vm-size Standard_D4s_v3
	az aks create -g kdocs -n "kdocscluster-aks" --enable-managed-identity --node-count 1 --ssh-key-value ~/.ssh/id_rsa.pub --node-vm-size Standard_D4s_v3

	# setup kubectl and its context
	az aks get-credentials --resource-group kdocs --name "kdocscluster-aks"
	# - kubectl config set-context "kdocscluster-aks"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10


akscluster-apply-km:
	echo "applying km to kind cluster: kdocscluster-aks"
	# kubectl apply -f outputs/km.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/km.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be ready"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 5
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-aks.log

	sleep 5

akscluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-aks"

	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

akscluster-clean:
	echo "deleting cluster: kdocscluster_aks"
	- kubectl config delete-context "kdocscluster-aks"
	az aks delete -y --name "kdocscluster-aks" --resource-group kdocs

#------------------
gke-setup:
	echo "setup gcloud CLI"
	# gcloud init with project and region

gkecluster:
	echo "setting up 1-node GKE cluster - kdocscluster-gke - using n2-standard-2 instance type"
	gcloud config set compute/zone "us-central1-c"
	gcloud config set project "gke-suport"
	gcloud beta container \
		clusters create "kdocscluster-gke" \
		--zone "us-central1-c" \
		--no-enable-basic-auth \
		--machine-type "n2-standard-2" \
		--image-type "UBUNTU_CONTAINERD" \
		--disk-type "pd-ssd" \
		--disk-size "50" \
		--num-nodes "1" \
		--node-locations "us-central1-c"

	# setup kubectl and its context
	gcloud container clusters get-credentials "kdocscluster-gke"
	# - kubectl config set-context "kdocscluster-gke"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10

gkecluster-apply-kkm:
	echo "applying kkm to kind cluster: kdocscluster-gke"
	# kubectl apply -f outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/kkm.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be running and applying KKM"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=240s

	sleep 60
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-gke.log

	sleep 5

gkecluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-gke"
	
	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

gkecluster-clean:
	echo "deleting cluster: kdocscluster-gke"
	- kubectl config delete-context "kdocscluster-gke"
	gcloud container clusters delete --quiet "kdocscluster-gke"

#------------------
ekscluster-setup:
	# 1-time task as it takes way too long to create a k8s cluster from scratch in cloudformation (sets up private subnet etc.)
	echo "setting up 1-node EKS cluster - kdocscluster-eks-2 - using t2.small instance type"
	eksctl create cluster -f aws/kdocscluster-eks-2.yaml
	# eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=us-west-2 --cluster=kdocscluster-eks

ekscluster:
	echo "setting up nodegroup for a 1-node EKS cluster - kdocscluster-eks-2 - using t2.small instance type"

	# it takes too long to create a cluster with the huge cloudformation stack generated, hence we will just add a nodegroup
	eksctl create nodegroup --config-file=./conf/aws/kdocscluster-eks-2.yaml

	# update kubeconfig
	aws eks update-kubeconfig --region us-west-2 --name "kdocscluster-eks-2"
	kubectl config current-context

	echo "waiting for all pods to be ready before cluster can be used"
	kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=720s
	sleep 10

ekscluster-apply-kkm:
	echo "applying kkm to kind cluster: kdocscluster-eks-2"
	# kubectl apply -f outputs/kkm.yaml && kubectl rollout status daemonset/kontain-node-initializer -n kube-system --timeout=240s
	kubectl apply -f outputs/kkm.yaml
	sleep 5

	echo "waiting for kontain-node-initializer to be running and applying KKM"
	kubectl -n kube-system wait pod --for=condition=Ready -l name=kontain-node-initializer --timeout=420s

	sleep 100
	echo "saving log output of kontain-node-initiliazer daemonset pod"
	kubectl logs daemonset/kontain-node-initializer -n kube-system > /tmp/kontain-node-initializer-eks.log

	sleep 5

ekscluster-apply-flaskapp:
	echo "deploying kontain flask app to cluster: kdocscluster-eks-2"

	# cleaning the app in case its already deployed, ignore error if present
	- kubectl delete -f apps/pyflaskappkontain.yml
	sleep 5

	echo "deploying the Kontain flask app"
	# kubectl apply -f apps/pyflaskappkontain.yml && kubectl rollout status deployment/flaskappkontain --timeout=60s
	kubectl apply -f apps/pyflaskappkontain.yml
	sleep 3

	echo "waiting for flask app to be ready"
	kubectl -n default wait pod --for=condition=Ready -l app=flaskappkontain --timeout=240s

	echo "getting pods in default NS"
	kubectl get po

ekscluster-clean:
	# takes too long to rebuild cluster hence not doing $ eksctl delete cluster --region=us-west-2 --name=kdocscluster-eks
	# we will just remove the node group, and scale it down to 0 to remove the nodes, ignore the pod disruption budgets
	echo "removing kontain-node-initializer"
	- kubectl delete deploy/flaskappkontain
	- kubectl delete daemonset/kontain-node-initializer -n kube-system
	sleep 5
	echo "draining the nodegroup to clean: kdocscluster-eks"
	eksctl drain nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --disable-eviction
	eksctl scale nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --nodes=0
	eksctl delete nodegroup --cluster=kdocscluster-eks-2 --name=kdocscluster-eks-2-ng-1 --disable-eviction
	# just to make sure node is removed
	eksctl delete nodegroup  --config-file=conf/aws/kdocscluster-eks-2.yaml --approve

	- kubectl config delete-context "kdocscluster-eks-2"
