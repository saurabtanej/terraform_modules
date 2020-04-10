/**
 * # Autoscaling group with Launch Templates
 *
 * Module example:
 *
 *     module "foo" {
 *       source                   = "../modules/asg-lt"
 *       asg_name                 = "foo-asg"
 *       image_id                 = "ami-12345"
 *       key_name                 = "foo-key"
 *       vpc_security_group_ids   = ["sg-12345"]
 *       iam_instance_profile_arn = "arn:aws:iam::123456789012:role/S3Access"
 *       user_data                = local.user_data_foo_node
 *       vpc_zone_identifier      = ["subnet-1234"]
 *       tag_name                 = "foo-asg"
 *       instance_types           = ["m5.2xlarge","r3.2xlarge","i3.2xlarge","r5.2xlarge"]
 *     }
 *
 */

locals {
  tags = merge(var.tags,
    {
      Name        = var.name,
      Environment = terraform.workspace,
      Role        = var.tag_role,
      Project     = var.tag_project,
      Owner       = var.tag_owner,
      Terraform   = "true"
    }
  )
}

resource "aws_launch_template" "main" {
  count                  = var.create ? 1 : 0
  image_id               = var.image_id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", "/dev/xvda")
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(list(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", "gp2")
        }
      }
    }
  }

  user_data = base64encode(var.user_data)
  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  tags = local.tags
}

resource "aws_autoscaling_group" "main" {
  count                     = var.create ? 1 : 0
  name                      = var.name
  vpc_zone_identifier       = var.vpc_zone_identifier
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  default_cooldown          = var.default_cooldown
  target_group_arns         = var.target_group_arns
  force_delete              = true
  enabled_metrics           = var.list_of_enabled_metrics

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.main[0].id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
      spot_instance_pools                      = var.spot_instance_pools
    }
  }
  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}
