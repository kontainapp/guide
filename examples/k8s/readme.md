# ref
```bash
# to start minikube
$ minikube start --container-runtime=cri-o --driver=podman

# to mount host fs to minikube
minikube mount $HOME:/home

# to put docker image into minikube
minikube ssh
cd <your-folder>
podman build -t .... 
