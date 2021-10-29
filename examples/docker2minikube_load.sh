export IMAGE=$1
docker save $IMAGE | pv | (eval $(minikube podman-env) && podman load)