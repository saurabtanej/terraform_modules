variable "project_name" {
  default = "infra"
}

variable "vpc_cidr_block" {}

variable "vpc_private_cidr_blocks" {
  type = list(string)
}

variable "vpc_public_cidr_blocks" {
  type = list(string)
}

variable "my_ip" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "aws_profile" {
  default = "example"
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "spot_instance_pools" {
  default = 4
}

variable "asg_min_size" {
  default = "0"
}

variable "asg_max_size" {
  default = "4"
}

variable "asg_desired_size" {
  default = "2"
}

variable "asg_instance_types" {
  type    = list(string)
  default = ["m3.medium", "t2.medium"]
}
