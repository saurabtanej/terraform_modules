variable "name" {
  description = "Name of the security group"
}

variable "vpc_id" {
  description = "The VPC ID to create the security group"
}

variable "create" {
  description = "Condition if security group should be created"
  type        = bool
  default     = true
}

variable "description" {
  description = "Security group description."
  default     = "Managed by Terraform"
}

variable "managed_ingress_rules" {
  description = "List of maps containing configuration of ingress rules `{port='8080',cidr_blocks=['1.1.1.1','1.2.3.4'],port='21-23',cidr_blocks=['1.1.1.1']}`."
  type        = any
  default     = []
}

variable "managed_egress_rules" {
  description = "List of maps containing configuration of egress rules `{port='8080',cidr_blocks=['1.1.1.1','1.2.3.4'],port='21-23',cidr_blocks=['1.1.1.1']}`."
  type        = any
  default     = []
}

variable "unmanaged_ingress_rules" {
  description = "Map of maps containing configuration of ingress rules `{foo={port='8080',cidr_blocks=['1.1.1.1','1.2.3.4']},bar={port='21-23',source_security_group_id='sg-1234'}}`."
  type        = any
  default     = {}
}

variable "unmanaged_egress_rules" {
  description = "Map containing configuration of egress rules `{foo={port='8080',cidr_blocks=['1.1.1.1','1.2.3.4']},bar={port='21-23',source_security_group_id='sg-1234'}}`."
  type        = any
  default     = {}
}

variable "ingress_rule_self_enabled" {
  description = "Condition if security group rule to allow self should be enabled"
  type        = bool
  default     = true
}

variable "egress_rule_allow_all_enabled" {
  description = "Condition if security group egress rule to allow all for outbound traffic should be enabled"
  type        = bool
  default     = true
}

variable "tags" {
  description = "List of maps of tags to add"
  type        = map(string)
  default     = {}
}
