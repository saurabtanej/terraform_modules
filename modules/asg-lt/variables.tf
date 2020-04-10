variable "name" {
  description = "Autoscaling group name"
  type        = string
  default     = ""
}

variable "image_id" {
  type        = string
  description = "The EC2 image ID to launch"
  default     = ""
}

variable "create" {
  description = "Condition if asg should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the launched instances"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_arn" {
  type        = string
  description = "The IAM instance profile arn to associate with launched instances"
  default     = ""
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = list(any)
  default     = [{ ebs = { volume_size = 100 } }]
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs to launch resources in"
  type        = list(string)

}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  type        = number
  default     = 100
}

variable "user_data" {
  description = "User data to provide when launching the instance"
  default     = ""
}

variable "max_size" {
  description = "Maximum size of the auto scale group"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum size of the auto scale group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Number of instances that should be running in the auto scale group"
  type        = number
  default     = 1
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done, can be either `EC2` or `ELB`"
  default     = "EC2"
}

variable "default_cooldown" {
  description = "Amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 60
}

variable "instance_types" {
  description = "List of order of preference of instance types to launch in the autoscaling group"
  type        = list(string)
  default     = ["m3.2xlarge", "r3.2xlarge", "r4.2xlarge", "i3.2xlarge"]
}

variable "tag_name" {
  description = "Name tag to associate with the autoscaling group"
}

variable "tag_project" {
  description = "Project tag to associate with the autoscaling group"
  default     = "infra"
}

variable "tag_owner" {
  description = "Owner tag to associate with the autoscaling group"
  default     = "devops"
}

variable "tag_role" {
  description = "Role tag to associate with the autoscaling group"
  default     = "asg"
}

variable "tags" {
  description = "List of maps of tags to add"
  type        = map(string)
  default     = {}
}

variable "on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  type        = number
  default     = 0
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
  type        = number
  default     = 0
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach to the split between on-demand and Spot instances above the base on-demand capacity"
  type        = list(string)
  default     = []
}

variable "spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity"
  type        = number
  default     = 2
}

variable "list_of_enabled_metrics" {
  description = "List of metrics to collect for the autoscaling group"
  type        = list(string)
  default     = ["GroupStandbyInstances", "GroupTotalInstances", "GroupPendingInstances", "GroupTerminatingInstances", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupMinSize", "GroupMaxSize"]
}
