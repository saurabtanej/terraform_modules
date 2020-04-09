# Terraform   

https://terraform.io/

## How to launch terraform

Configure AWS credentails:
Create new profile in ```~/.aws/credentials``` called example, see example below
```

[example]
aws_access_key_id = "AKIXXXXXXXXXXXXXXXX"
aws_secret_access_key = "lXXXXXXXXXXXXXXXXXXXXXXXXG"
```

Commands
```
terraform plan                  -   Give an idea about the resources to be created, deleted, modified.

terraform workspace select/list -  Select workspace (usefule for creating different environments without duplicating the terraform files)

terraform apply                 -  Apply the terraform on the infrastructure.

```
