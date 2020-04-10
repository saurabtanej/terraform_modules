/**
 * # VPC module
 *
 * Module example:
 *
 *     module "foo" {
 *       source          = "./modules/vpc"
 *       vpc_name        = "foo"
 *       project_name    = "foo"
 *       cidr            = "10.10.10.0/16"
 *       azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
 *       private_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
 *       public_subnets  = ["10.10.13.0/24", "10.10.14.0/24", "10.10.15.0/24"]
 *     }
 *
 */

locals {
  max_subnet_length = max(length(var.private_subnets))
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  vpc_id            = element(concat(aws_vpc.this.*.id, [""], ), 0, )
  tags = merge(var.tags,
    {
      Environment = terraform.workspace,
      Role        = var.tag_role,
      Project     = var.tag_project,
      Owner       = var.tag_owner,
      Terraform   = "true"
    }
  )
}


######
# VPC
######
resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.tags, { "Name" = var.vpc_name })

  lifecycle {
    prevent_destroy = true
  }
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(local.tags, { "Name" = "${var.project_name}-${terraform.workspace}" })

  lifecycle {
    prevent_destroy = true
  }
}

##############
# NAT Gateway
##############
resource "aws_eip" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(local.tags,
    {
      Name = "${var.project_name}-${count.index}-${terraform.workspace}"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_nat_gateway" "this" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index,
  )

  tags = merge(local.tags,
    {
      Name = "${var.project_name}-${count.index}-${terraform.workspace}"
    }
  )

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [aws_internet_gateway.this]
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = "${var.aws_region}${element(split(":", var.azs[var.aws_region]), count.index)}"
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(local.tags,
    {
      "Name" = "${var.project_name}-public-${element(split(":", var.azs[var.aws_region]), count.index)}-${terraform.workspace}"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = "${var.aws_region}${element(split(":", var.azs[var.aws_region]), count.index)}"

  tags = merge(local.tags,
    {
      "Name" = "${var.project_name}-private-${element(split(":", var.azs[var.aws_region]), count.index)}-${terraform.workspace}"
    }
  )
  lifecycle {
    prevent_destroy = true
  }
}
