/**
 * # IAM Role module
 *
 * Module example:
 *
 *     module "foo" {
 *       source = "../modules/iam-role"
 *       name   = "foo-role"
 *     }
 *
 *
 * Default `assume_role_policy` if not specified:
 *
 *     {
 *       "Version": "2012-10-17",
 *       "Statement": [
 *         {
 *           "Action": "sts:AssumeRole",
 *           "Principal": {
 *             "Service": "ec2.amazonaws.com"
 *           },
 *           "Effect": "Allow"
 *         }
 *       ]
 *     }
 *
 *
 * Default `iam_policy` if not specified:
 *
 *     {
 *       "Version": "2012-10-17",
 *       "Statement": [
 *         {
 *           "Effect": "Allow",
 *           "Action": [
 *             "ec2:DescribeInstances"
 *           ],
 *           "Resource": [ "*" ]
 *         }
 *       ]
 *     }
 */

locals {
  name = replace(var.name, "/[^0-9A-Za-z_+=,.@-]/", "-")
}

resource "aws_iam_role" "iam_role" {
  count              = var.create ? 1 : 0
  name               = local.name
  assume_role_policy = var.assume_role_policy != null ? var.assume_role_policy : data.aws_iam_policy_document.assume.json
  tags               = merge(var.tags, { "Name" = var.name })
}

resource "aws_iam_instance_profile" "iam_profile" {
  count = var.create && var.create_instance_profile ? 1 : 0
  name  = aws_iam_role.iam_role[count.index].name
  role  = aws_iam_role.iam_role[count.index].name
}

resource "aws_iam_role_policy" "iam_policy" {
  count  = var.create && var.iam_policy != null ? 1 : 0
  name   = aws_iam_role.iam_role[count.index].name
  role   = aws_iam_role.iam_role[count.index].id
  policy = var.iam_policy
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  count      = var.create ? length(var.policy_arns) : 0
  role       = aws_iam_role.iam_role[0].name
  policy_arn = var.policy_arns[count.index]
}
