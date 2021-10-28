# Image Tagging and Docker Registries
You can use the regular Docker commands to tag and image

You can use *Docker pull* and *Docker push* to work with the any Docker registry (local registry, Docker Hub, AWS ECR, Google Compute GCR, Azure ACR) in the same manner as regular Docker images.


```sh
# you can use the regular Docker commands for tagging, 
#   and for pulling from, and pushing Docker images to the registry
# to tag an image
$ docker tag <source_image:tag> <registry/image:tag>
$ docker tag <source_image_id> <registry/image:tag>

# to push an image to the registry
$ docker push <registry>/<imagename:tag>

# to pull an image
$ docker pull <registry>/<imagename:tag>
```