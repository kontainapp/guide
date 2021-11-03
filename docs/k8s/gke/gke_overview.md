# Kontain on GKE

Instructions on how to run kontain on GKE. Currently experimenting. Will consolodate into coherent doc when we know how to do it.

Results of experiments with <https://github.com/GoogleCloudPlatform/solutions-gke-init-daemonsets-tutorial>

- Use 'unbuntu_containerd' image type.
- With default security access scopes the disk manipulations in the daemonset example fail. Set "Allow access to all Google Cloud API's".
