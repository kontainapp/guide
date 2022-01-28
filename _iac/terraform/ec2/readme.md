# ref
https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started

# steps
NOTE - needs a default VPC to be pre-configured
```bash
$ terraform init

$ terra validate

$ terraform apply

$ terraform destroy

# change name
$ terraform apply -var "instance_name=YetAnotherName"
...
will update-in-place

# queries output
$ terraform output

