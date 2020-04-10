# Terraform   

https://terraform.io/

## Prerequisite
Terraform version >= 0.12

## How to launch terraform

Configure AWS credentails:
Create new profile in ```~/.aws/credentials``` called example or any(change aws_profile variable in vars.tf with that name), see example below
```

[example]
aws_access_key_id = "AKIXXXXXXXXXXXXXXXX"
aws_secret_access_key = "lXXXXXXXXXXXXXXXXXXXXXXXXG"
```

Create Terraform workspace of your choice by running
```
terraform workspace new ${workspace_name} # workspace_name can be any env name of your choice.
```
Workspace is used to avoid duplication of .tf files to create a new env. Use the same .tf files and create a new `env-${workspace}.tfvars`

Commands
```
terraform plan                  -   Give an idea about the resources to be created, deleted, modified.

terraform workspace select/list -  Select workspace (useful for creating different environments without duplicating the terraform files)

terraform validate              -  Validates local configuration without touching the remote state

terraform apply                 -  Apply the terraform on the infrastructure.

terraform fmt                   -  Format the terraform definition.

```

Example and README has been updated with each module on how to use it.

# Example Usage

```
terraform plan -var-file=env-example.tfvars
```

This will try to create a VPC with 3 private and 3 public subnets and set up the whole networking including NAT GWs and Internet GWs.
This will also try to create an ASG of 2 instance (initially) of mix of On Demand and Spot Instances, An IAM role and SG that will be attached to the ASG.
All the resources have been created using the modules.

Example usage and README for each module has been updated accordingly.

# To DO:
* Add Github actions to validate and check formatting of terraform
* Add Makefile for the project
