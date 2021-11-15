# exports all vars
# .EXPORT_ALL_VARIABLES:


create_cluster:
	set -x
	minikube start -p kontain --container-runtime=containerd --driver=docker --wait=all
	sleep 2
	minikube profile list
	kubectl get pods -n kube-system


delete_cluster:
	minikube -p kontain delete


deploy_kontain:
	set -x
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/runtime-class.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/cm-install-lib.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/cm-containerd-install.yaml
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/cloud/k8s/deploy/kontain-deploy.yaml
	sleep 4
	kubectl get daemonsets.apps -A
	kubectl get pods -A


deploy_testapp:
	set -x
	kubectl apply -f https://raw.githubusercontent.com/kontainapp/km/master/demo/k8s/test.yaml
	sleep 4
	kubectl get pods
	sleep 10
	echo "Please run: kubectl exec -it kontain-test-app-<pod_id>  -- uname -r"