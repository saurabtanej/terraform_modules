module "vpc" {
  source                  = "../../modules/vpc"
  vpc_name                = "${var.project_name}-vpc-${terraform.workspace}"
  project_name            = var.project_name
  cidr                    = var.vpc_cidr_block
  public_subnets          = var.vpc_public_cidr_blocks
  private_subnets         = var.vpc_private_cidr_blocks
  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = terraform.workspace == "example" ? true : false
}
