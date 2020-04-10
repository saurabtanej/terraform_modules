output "name" {
  description = "Name of the IAM role"
  value       = concat(aws_iam_role.iam_role.*.name, [""])[0]
}

output "role_date" {
  value = concat(aws_iam_role.iam_role.*.create_date, [""])[0]
}

output "role_id" {
  value = concat(aws_iam_role.iam_role.*.unique_id, [""])[0]
}

output "role_arn" {
  value = concat(aws_iam_role.iam_role.*.arn, [""])[0]
}

output "policy_id" {
  value = concat(aws_iam_role_policy.iam_policy.*.id, [""])[0]
}

output "policy_name" {
  value = concat(aws_iam_role_policy.iam_policy.*.name, [""])[0]
}

output "policy_doc" {
  value = concat(aws_iam_role_policy.iam_policy.*.policy, [""])[0]
}

output "policy_role" {
  value = concat(aws_iam_role_policy.iam_policy.*.role, [""])[0]
}

output "profile_id" {
  value = concat(aws_iam_instance_profile.iam_profile.*.id, [""])[0]
}

output "profile_arn" {
  value = concat(aws_iam_instance_profile.iam_profile.*.arn, [""])[0]
}

output "profile_path" {
  value = concat(aws_iam_instance_profile.iam_profile.*.path, [""])[0]
}

output "profile_roles" {
  value = aws_iam_instance_profile.iam_profile.*.roles
}

output "profile_unique_id" {
  value = concat(aws_iam_instance_profile.iam_profile.*.unique_id, [""])[0]
}

output "profile_name" {
  value = concat(aws_iam_instance_profile.iam_profile.*.name, [""])[0]
}
