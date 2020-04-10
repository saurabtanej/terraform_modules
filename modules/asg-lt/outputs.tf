output "aws_autoscaling_group_id" {
  description = "Autoscaling group ID"
  value       = concat(aws_autoscaling_group.main.*.id, [""])[0]
}

output "aws_autoscaling_group_name" {
  description = "Autoscaling group name"
  value       = concat(aws_autoscaling_group.main.*.name, [""])[0]
}

output "aws_autoscaling_maxsize" {
  description = "Autoscaling group max size"
  value       = concat(aws_autoscaling_group.main.*.max_size, [""])[0]
}

output "aws_autoscaling_minsize" {
  description = "Autoscaling group min size"
  value       = concat(aws_autoscaling_group.main.*.min_size, [""])[0]
}
