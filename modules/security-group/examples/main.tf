provider "aws" {
  version = ">= 2.17"
  region  = var.region
}

variable "region" {
  default = "ap-southeast-1"
}

variable "vpc_id" {
  default = "vpc-2f09a348"
}

module "sg_basic" {
  source = "../"
  name   = "foo-sg-basic"
  vpc_id = var.vpc_id
}

module "sg_managed_rules_1" {
  source = "../"
  name   = "foo-sg-managed-rules-1"
  vpc_id = var.vpc_id
  managed_ingress_rules = [{
    port            = 80
    security_groups = ["sg-1234567"]
    description     = "http access from foo-sg"
  }]
}

module "sg_managed_rules_2" {
  source = "../"
  name   = "foo-sg-managed-rules-2"
  vpc_id = var.vpc_id
  managed_ingress_rules = [
    {
      port            = 80
      security_groups = ["sg-1234567"]
      description     = "http access from foo-sg"
    },
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "http access from all"
    }
  ]
}

module "sg_unmanaged_rules_1" {
  source = "../"
  name   = "foo-sg-unmanaged-rules-1"
  vpc_id = var.vpc_id
  unmanaged_ingress_rules = {
    rule-1 = {
      port        = 2049
      cidr_blocks = ["1.2.3.4/23"]
      description = "Managed by Terraform"
    }
  }
}

module "sg_unmanaged_rules_2" {
  source = "../"
  name   = "foo-sg-unmanaged-rules-2"
  vpc_id = var.vpc_id
  unmanaged_ingress_rules = {
    rule-1 = {
      port        = 22
      cidr_blocks = ["1.2.3.4/23"]
      description = "Managed by Terraform"
    }
    rule-2 = {
      port                     = 80
      source_security_group_id = "sg-1234"
      description              = "Managed by Terraform"
    }
  }
}

module "sg_unmanaged_rules_3" {
  source = "../"
  name   = "foo-sg-unmanaged-rules-2"
  vpc_id = var.vpc_id
  unmanaged_ingress_rules = {
    rule-1 = {
      port        = 22
      cidr_blocks = ["1.2.3.4/23"]
      description = "Managed by Terraform"
    }
    rule-2 = {
      port                     = 80
      source_security_group_id = "sg-1234"
      description              = "Managed by Terraform"
    }
  }
  unmanaged_egress_rules = {
    rule-1 = {
      port        = 22
      cidr_blocks = ["1.2.3.4/23"]
      description = "Managed by Terraform"
    }
    rule-2 = {
      port                     = 80
      source_security_group_id = "sg-1234"
      description              = "Managed by Terraform"
    }
  }
}
