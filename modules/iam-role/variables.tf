variable "name" {
}

variable "create" {
  description = "Controls if IAM resources should be created (useful for conditional switching of module creation)"
  type        = bool
  default     = true
}

variable "create_instance_profile" {
  description = "Option whether to create the IAM instance role"
  type        = bool
  default     = true
}

variable "iam_policy" {
  default = null
}

variable "assume_role_policy" {
  default = null
}

variable "policy_arns" {
  description = "List of Policy ARNs to attach to an IAM role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
  default     = {}
}
