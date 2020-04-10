output "id" {
  description = "ID of the security group"
  value       = concat(aws_security_group.this.*.id, [""])[0]
}
