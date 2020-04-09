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

variable "aws_profile" {
  default = "example"
}

variable "aws_region" {
  default = "ap-southeast-1"
}
