# bring up cluster
```shell
$ ./up.sh
```

After bringng up the multi-node k3s cluster in Vagrant, you can use the following to run kubectl commands on the cluster:
```shell
$ export KUBECONFIG=./shared/server_details/kubeconfig
```
