# Autoscaling group with Launch Templates

Module example:

    module "foo" {
      source                   = "../modules/asg-lt"
      asg_name                 = "foo-asg"
      image_id                 = "ami-12345"
      key_name                 = "foo-key"
      vpc_security_group_ids   = ["sg-12345"]
      iam_instance_profile_arn = "arn:aws:iam::123456789012:role/S3Access"
      user_data                = local.user_data_foo_node
      vpc_zone_identifier      = ["subnet-1234"]
      tag_name                 = "foo-asg"
      instance_types           = ["m5.2xlarge","r3.2xlarge","i3.2xlarge","r5.2xlarge"]
      tags = {
        "iac:tool" = "terraform"
      }
    }

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asg\_name | Autoscaling group name | string | n/a | yes |
| create | Condition if asg should be created (it affects almost all resources) | bool | `"true"` | no |
| default\_cooldown | Amount of time, in seconds, after a scaling activity completes before another scaling activity can start | number | `"60"` | no |
| desired\_capacity | Number of instances that should be running in the auto scale group | number | `"1"` | no |
| health\_check\_grace\_period | Time (in seconds) after instance comes into service before checking health | number | `"300"` | no |
| health\_check\_type | Controls how health checking is done, can be either `EC2` or `ELB` | string | `"EC2"` | no |
| iam\_instance\_profile\_arn | Instance Profile to  associate with the launched instances | string | `""` | no |
| image\_id | Image AMI from which to launch the instance | string | n/a | yes |
| instance\_types | List of order of preference of instance types to launch in the autoscaling group | list(string) | `<list>` | no |
| key\_name | Key name to use for the launched instances | string | n/a | yes |
| list\_of\_enabled\_metrics | List of metrics to collect for the autoscaling group | list(string) | `<list>` | no |
| max\_size | Maximum size of the auto scale group | number | `"1"` | no |
| min\_size | Minimum size of the auto scale group | number | `"1"` | no |
| on\_demand\_base\_capacity | Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances | number | `"0"` | no |
| on\_demand\_percentage\_above\_base\_capacity | Percentage split between on-demand and Spot instances above the base on-demand capacity | number | `"0"` | no |
| root\_volume\_size | Size of the root volume in gigabytes | number | `"100"` | no |
| spot\_instance\_pools | Number of Spot pools per availability zone to allocate capacity | number | `"2"` | no |
| tag\_name | Name tag to associate with the autoscaling group | string | n/a | yes |
| tag\_owner | Owner tag to associate with the autoscaling group | string | `"devops"` | no |
| tag\_project | Project tag to associate with the autoscaling group | string | `"infra"` | no |
| tag\_role | Role tag to associate with the autoscaling group | string | `"asg"` | no |
| tags | List of maps of tags to add | map(string) | `<map>` | no |
| target\_group\_arns | List of target group ARNs to attach to the split between on-demand and Spot instances above the base on-demand capacity | list(string) | `<list>` | no |
| user\_data | User data to provide when launching the instance | string | `""` | no |
| vpc\_security\_group\_ids | List of security group IDs to associate with the launched instances | list(string) | `<list>` | no |
| vpc\_zone\_identifier | List of subnet IDs to launch resources in | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_autoscaling\_group\_id | Autoscaling group ID |
| aws\_autoscaling\_group\_name | Autoscaling group name |
| aws\_autoscaling\_maxsize | Autoscaling group max size |
| aws\_autoscaling\_minsize | Autoscaling group min size |
