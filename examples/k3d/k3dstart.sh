# k3d cluster create --verbose --trace --no-rollback 

#--volume `pwd`/kontain-artifacts/config_toml_tmpl/config.toml.tmpl:/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl
#--volume `pwd`/kontain-artifacts/cloud/k8s/deploy/shim/containerd-shim-krun-v2:/bin/containerd-shim-krun-v2 
#--volume `pwd`/kontain-artifacts/container-runtime/krun:/opt/kontain/bin/krun 
#--volume `pwd`/kontain-artifacts/km/km:/opt/kontain/bin/km --wait --verbose 

# when debugging
# --verbose
# --trace --no-rollback


# with config.yaml and disabling traefik
k3d cluster create --config ./config.yaml --trace --k3s-arg --disable=traefik@server:0