# Test App for Kubernetes
Below is the deployment specification for a simple Test App which is just busybox wrapped in a Kontain container but offers a view of how Kontain's runtime is used when instantiating a pod that's a Kontain container image.


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kontain-test-app
spec:
  selector:
    matchLabels:
      kontain: test-app
  template:
    metadata:
      labels:
        kontain: test-app
    spec:
      runtimeClassName: kontain
      containers:
      - name: kontain-test-app
        image: busybox:latest
        command: [ "sleep", "infinity" ]
        imagePullPolicy: IfNotPresent
```