# VPC parameters
vpc_cidr_block = "10.30.0.0/16"

vpc_private_cidr_blocks = ["10.30.6.0/24", "10.30.8.0/24", "10.30.9.0/24"]
vpc_public_cidr_blocks  = ["10.30.0.0/24", "10.30.1.0/24", "10.30.11.0/24"]
aws_region              = "eu-west-1"

#SG Parameters to provide access to self IP
my_ip                   = ["10.30.6.0/24"]
