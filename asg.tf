# Change this public_key with your own pubic key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/FnrdZnrL4zKajD0Gzm3pzlgTB5/OQ8cdveWsmbRgszLa/fYXNYFG7ZcpRz8h7nCarVzmlt2h6xcZ9fCwIzpWmEtmzQYx5DCnGrTCG1VGzHbE42MNL/3jouLjg8Yicfb8z7xjH3QZtldUJOwN4/io2vAQQhF14OsdLskUJxfy+0fn5TRo5Byz+FzlwWvVUK+5jgoXjBaZx/DnB3J7k3W9aAVWndXI1XQ6f7GSJn73l0HUCt3Qfge8aK+EVCxpajWXwBIfTF7juBU8Bh5qx0sQSq1T7xscCN2fswCNxbh6ydhheyMbDaCVRzHODgd0dr0FfrNxuJ3h0PLDdUE/OH8/ saurabdh@Saurabdhs-MacBook-Pro.local"
}

# This will create an ASG of 2 instance (one on demand and one spot)
module "asg_worker" {
  source                                   = "./modules/asg-lt"
  name                                     = "worker-${terraform.workspace}"
  image_id                                 = data.aws_ami_ids.ubuntu.id
  key_name                                 = aws_key_pair.deployer.key_name
  vpc_security_group_ids                   = [module.asg_sg.id]
  iam_instance_profile_arn                 = module.asg-iam.role_arn
  vpc_zone_identifier                      = module.vpc.private_subnets
  user_data                                = templatefile("./templates/userdata.sh.tpl", {})
  tag_name                                 = "worker-${terraform.workspace}"
  min_size                                 = var.asg_min_size
  max_size                                 = var.asg_max_size
  desired_capacity                         = var.asg_desired_size
  instance_types                           = var.asg_instance_types
  spot_instance_pools                      = var.spot_instance_pools
  on_demand_percentage_above_base_capacity = 50
}
