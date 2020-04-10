# IAM Role module

Module example:

    module "foo" {
      source = "../modules/iam-role"
      name   = "foo-role"
    }

Default `assume_role_policy` if not specified:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }

Default `iam_policy` if not specified:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeInstances"
          ],
          "Resource": [ "\*" ]
        }
      ]
    }

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| assume\_role\_policy | n/a | `any` | n/a | yes |
| iam\_policy | n/a | `any` | n/a | yes |
| name | n/a | `any` | n/a | yes |
| create | Controls if IAM resources should be created (useful for conditional switching of module creation) | `bool` | `true` | no |
| create\_instance\_profile | Option whether to create the IAM instance role | `bool` | `true` | no |
| policy\_arns | List of Policy ARNs to attach to an IAM role | `list(string)` | `[]` | no |
| tags | A map of tags to add to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Name of the IAM role |
| policy\_doc | n/a |
| policy\_id | n/a |
| policy\_name | n/a |
| policy\_role | n/a |
| profile\_arn | n/a |
| profile\_id | n/a |
| profile\_name | n/a |
| profile\_path | n/a |
| profile\_roles | n/a |
| profile\_unique\_id | n/a |
| role\_arn | n/a |
| role\_date | n/a |
| role\_id | n/a |

