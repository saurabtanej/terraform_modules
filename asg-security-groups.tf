module "asg_sg" {
  source = "./modules/security-group"
  name   = "foo"
  vpc_id = module.vpc.id
  managed_ingress_rules = [
    {
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "http access from foo-sg"
    },
    {
      port        = "3000-6000"
      cidr_blocks = var.my_ip
      description = "allow custom ports from foo-sg"
    },
    {
      port        = 22
      cidr_blocks = var.my_ip
      description = "allow custom ports from foo-sg"
  }]
}
