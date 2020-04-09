# VPC module

Module example:

    module "foo" {
      source          = "../modules/vpc"
      vpc\_name        = "foo"
      project\_name    = "foo"
      cidr            = "10.10.10.0/16"
      azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
      private\_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
      public\_subnets  = ["10.10.13.0/24", "10.10.14.0/24", "10.10.15.0/24"]
    }

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | n/a | yes |
| aws\_region | n/a | `string` | `"ap-southeast-1"` | no |
| azs | A list of availability zones in the region | `map(string)` | <pre>{<br>  "ap-southeast-1": "a:b:c",<br>  "eu-west-1": "a:b:c",<br>  "us-east-1": "b:c:d"<br>}</pre> | no |
| create\_vpc | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| eks\_cluster\_name | n/a | `string` | `""` | no |
| enable\_dns\_hostnames | Should be true to enable DNS hostnames in the Default VPC | `bool` | `true` | no |
| enable\_dns\_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| enable\_nat\_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| map\_public\_ip\_on\_launch | Should be false if you do not want to auto-assign public IP on launch | `bool` | `false` | no |
| one\_nat\_gateway\_per\_az | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`. | `bool` | `false` | no |
| private\_eks\_subnets | A list of private eks subnets inside the VPC | `list(string)` | `[]` | no |
| private\_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| project\_name | The name of the project to be applied | `string` | `""` | no |
| public\_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| single\_nat\_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| tag\_owner | Owner tag to apply to the instance | `string` | `"devops"` | no |
| tag\_project | Project tag to apply to the instance | `string` | `"infra"` | no |
| tag\_role | Role tag to apply to the instance | `string` | `"vpc"` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_name | The VPC name to be applied | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cidr\_block | The CIDR block of the VPC |
| id | The ID of the VPC |
| igw\_id | The ID of the Internet Gateway |
| nat\_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat\_public\_ips | List of public Elastic IPs created for AWS NAT Gateway |
| natgw\_ids | List of NAT Gateway IDs |
| private\_eks\_subnets | List of IDs of private eks subnets |
| private\_subnets | List of IDs of private subnets |
| public\_subnets | List of IDs of public subnets |
