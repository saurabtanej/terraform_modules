/**
 * ## Security group module
 *
 * This security module supports both rules **managed within** the security group resource and rules **managed outside** the security group resource
 *
 * Module example with managed rules within security group (RECOMMENDED):
 *
 *     module "foo" {
 *       source = "../modules/security-group"
 *       name   = "foo"
 *     }
 *     module "foo" {
 *       source      = "../modules/security-group"
 *       name        = "foo"
 *       vpc_id      = "vpc-12345"
 *       managed_ingress_rules = [
 *       {
 *         port            = 80
 *         security_groups = ["sg-1234567"]
 *         description     = "http access from foo-sg"
 *       },
 *       {
 *         port            = "3000-6000"
 *         security_groups = ["sg-1234567"]
 *         description     = "allow custom ports from foo-sg"
 *       }]
 *     }
 *
 * Module example with managed rules outside the security group:
 *
 *     module "foo" {
 *       source      = "../modules/security-group"
 *       name        = "foo"
 *       vpc_id      = "vpc-12345"
 *       unmanaged_ingress_rules = {
 *         "rule-name-1" = {
 *           port                     = 80
 *           source_security_group_id = "sg-1234567"
 *           description              = "http access from foo-sg"
 *         },
 *         "rule-name-2" = {
 *           port            = "3000-6000"
 *           cidr_blocks     = ["1.1.1.1","1.2.3.4"]
 *           description     = "allow custom ports from foo-sg"
 *         }
 *       }
 *     }
 *
 */

locals {
  # check if it should be managed/unmanaged based on the total count of unmanaged ingress/egress rules
  managed_rules   = (length(keys(var.unmanaged_ingress_rules)) + length(keys(var.unmanaged_egress_rules))) == 0 ? true : false
  unmanaged_rules = var.create && ! local.managed_rules ? true : false
  ingress_rule_self = {
    "false" = []
    "true" = [{
      description = "Access from self"
      port        = 0
      protocol    = "-1"
      self        = true
    }]
  }
  egress_rule_allow_all = {
    "false" = []
    "true" = [{
      description = "Egress to all"
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }]
  }
  ingress_rules_config = {
    "false" = []
    "true"  = concat(var.managed_ingress_rules, local.ingress_rule_self[var.ingress_rule_self_enabled])
  }
  egress_rules_config = {
    "false" = []
    "true"  = concat(var.managed_egress_rules, local.egress_rule_allow_all[var.egress_rule_allow_all_enabled])
  }
  unmanaged_ingress_rules = {
    "false" = {}
    "true"  = var.unmanaged_ingress_rules
  }
  unmanaged_egress_rules = {
    "false" = {}
    "true"  = var.unmanaged_egress_rules
  }
}

resource "aws_security_group" "this" {
  count       = var.create ? 1 : 0
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = local.ingress_rules_config[local.managed_rules]
    content {
      description     = lookup(ingress.value, "description", "")
      from_port       = split("-", ingress.value.port)[0]
      to_port         = length(split("-", ingress.value.port)) == 2 ? split("-", ingress.value.port)[1] : split("-", ingress.value.port)[0]
      protocol        = lookup(ingress.value, "protocol", "tcp")
      security_groups = lookup(ingress.value, "security_groups", null)
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      self            = lookup(ingress.value, "self", null)
    }
  }
  dynamic "egress" {
    for_each = local.egress_rules_config[local.managed_rules]
    content {
      description     = lookup(egress.value, "description", "")
      from_port       = split("-", egress.value.port)[0]
      to_port         = length(split("-", egress.value.port)) == 2 ? split("-", egress.value.port)[1] : split("-", egress.value.port)[0]
      protocol        = lookup(egress.value, "protocol", "tcp")
      security_groups = lookup(egress.value, "security_groups", null)
      cidr_blocks     = lookup(egress.value, "cidr_blocks", null)
      self            = lookup(egress.value, "self", null)
    }
  }
  tags = merge(var.tags, { Name = var.name, Environment = terraform.workspace, Terraform = "true" })
}

resource "aws_security_group_rule" "ingress_self" {
  count             = var.create && ! local.managed_rules && var.ingress_rule_self_enabled ? 1 : 0
  type              = "ingress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  self              = true
  description       = "Access from self"
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each                 = local.unmanaged_ingress_rules[local.unmanaged_rules]
  type                     = "ingress"
  to_port                  = split("-", each.value.port)[0]
  from_port                = length(split("-", each.value.port)) == 2 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
  protocol                 = lookup(each.value, "protocol", "tcp")
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description              = lookup(each.value, "description", "")
  security_group_id        = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "egress_all" {
  count             = (var.create && ! local.managed_rules && var.egress_rule_allow_all_enabled) ? 1 : 0
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress to all"
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "egress_rules" {
  for_each                 = local.unmanaged_egress_rules[local.unmanaged_rules]
  type                     = "egress"
  to_port                  = split("-", each.value.port)[0]
  from_port                = length(split("-", each.value.port)) == 2 ? split("-", each.value.port)[1] : split("-", each.value.port)[0]
  protocol                 = lookup(each.value, "protocol", "tcp")
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description              = lookup(each.value, "description", "")
  security_group_id        = aws_security_group.this[0].id
}
