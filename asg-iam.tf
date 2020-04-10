module "asg-iam" {
  source     = "./modules/iam-role"
  name       = "asg-${terraform.workspace}"
  iam_policy = data.aws_iam_policy_document.asg.json
}
