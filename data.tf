data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}

data "aws_iam_policy_document" "asg" {
  statement {
    actions = [
      "ec2:Describe*"
    ]
    resources = [
      "*"
    ]
  }
}
