# ref
builddockerimg.sh  buildkontainimg.sh  docker-compose.yml  Dockerfile.docker  Dockerfile.kontain  down.sh  readme.md  requirements.txt  up.sh

NOTE - uses the cluster config in ~/.ecs/config with region and profile in ~/.ecs/credentials
```bash
# 1-time - configure ECS cluster
$ aws ecs-cli configure --cluster ecstestclstr2 --default-launch-type EC2 --config-name ecstestclstr2 --region us-west-2

# 1-time - configure your credentials
$ aws ecs-cli configure --profile-name kontain --access-key <access-key> --secret-key <secret-key>

# 1-time - configure ECS cluster
$ aws ecs-cli configure --cluster ecstestclstr2 --default-launch-type EC2 --config-name ecstestclstr2 --region us-west-2

# list clusters
$ aws ecs list-clusters

# list hosts
$ aws ecs list-container-instances

# list deployments
$ aws ecs list-tasks --cluster ecstestclstr2


# builds and pushes kontain image
$ docker build -f Dockerfile.kontain -t sandman2k/pyflaskkontain .
or
# if you dont want to put the label inside the Dockerfile
# https://codefresh.io/docs/docs/codefresh-yaml/docker-image-metadata/
$ docker build -t sandman2k/pyflaskdocker --label "container_type"="kontain" -f Dockerfile.docker
$ docker push sandman2k/pyflaskkontain

# to run a test locally
$ docker run --rm  -p 5000:5000 --name pyflaskex sandman2k/pyflaskdocker
# in another terminal
$ curl http://localhost:5000/
$ docker inspect --format='{{.Config.Labels.CONTAINER_TYPE}}' pyflaskex
KONTAIN
$ docker inspect --format='{{.Config.Labels.container_type}}' pyflaskex
kontain

# to test on ECS
# ecs UP - starts docker-compose app(docker image) in ECS
$ ecs-cli compose up --create-log-groups --cluster-config ecstestclstr2 --ecs-profile kontain

# status and note the public IP and port
# ecs-cli compose service ps
$ ecs-cli ps --cluster-config ecstestclstr2 --ecs-profile kontain

# CURL
$ curl http://<public-ip-address>:5000

# query security group for open ports
$ aws ec2 describe-security-groups --filters Name=vpc-id,Values=vpc-03920d95558866f7a  --region us-west-2

# ecs down - stops docker-compose app(docker image) in ECS
$ ecs-cli compose service rm --cluster-config ecstestclstrec4 --ecs-profile kontain

$ aws ecs list-clusters
or
$ aws ecs list-container-instances

$ aws ecs list-tasks --cluster ecstestclstr2 # --container-instance <value> for the specific node and other params like launch-type etc

# usually the last task
$ ecs-cli logs --task-id <taskid>
```