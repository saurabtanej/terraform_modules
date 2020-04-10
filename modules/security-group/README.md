## Security group module

This security module supports both rules **managed within** the security group resource and rules **managed outside** the security group resource

Module example with managed rules within security group (RECOMMENDED):

    module "foo" {
      source = "../modules/security-group"
      name   = "foo"
    }
    module "foo" {
      source      = "../modules/security-group"
      name        = "foo"
      vpc_id      = "vpc-12345"
      managed_ingress_rules = [
      {
        port            = 80
        security_groups = ["sg-1234567"]
        description     = "http access from foo-sg"
      },
      {
        port            = "3000-6000"
        security_groups = ["sg-1234567"]
        description     = "allow custom ports from foo-sg"
      }]
    }

Module example with managed rules outside the security group:

    module "foo" {
      source      = "../modules/security-group"
      name        = "foo"
      vpc_id      = "vpc-12345"
      unmanaged_ingress_rules = {
        "rule-name-1" = {
          port                     = 80
          source_security_group_id = "sg-1234567"
          description              = "http access from foo-sg"
        },
        "rule-name-2" = {
          port            = "3000-6000"
          cidr_blocks     = ["1.1.1.1","1.2.3.4"]
          description     = "allow custom ports from foo-sg"
        }
      }
    }

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name of the security group | string | n/a | yes |
| vpc\_id | The VPC ID to create the security group | string | n/a | yes |
| create | Condition if security group should be created | bool | `"true"` | no |
| description | Security group description. | string | `"Managed by Terraform"` | no |
| egress\_rule\_allow\_all\_enabled | Condition if security group egress rule to allow all for outbound traffic should be enabled | bool | `"true"` | no |
| ingress\_rule\_self\_enabled | Condition if security group rule to allow self should be enabled | bool | `"true"` | no |
| managed\_egress\_rules | List of maps containing configuration of egress rules `{port='8080',cidr_blocks=['1.1.1.1','1.2.3.4'],port='21-23',cidr_blocks=['1.1.1.1']}`. | any | `[]` | no |
| managed\_ingress\_rules | List of maps containing configuration of ingress rules `{port='8080',cidr_blocks=['1.1.1.1','1.2.3.4'],port='21-23',cidr_blocks=['1.1.1.1']}`. | any | `[]` | no |
| tags | List of maps of tags to add | map(string) | `{}` | no |
| unmanaged\_egress\_rules | Map containing configuration of egress rules `{foo={port='8080',cidr_blocks=['1.1.1.1','1.2.3.4']},bar={port='21-23',source_security_group_id='sg-1234'}}`. | map(any) | `{}` | no |
| unmanaged\_ingress\_rules | Map of maps containing configuration of ingress rules `{foo={port='8080',cidr_blocks=['1.1.1.1','1.2.3.4']},bar={port='21-23',source_security_group_id='sg-1234'}}`. | map(any) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the security group |

