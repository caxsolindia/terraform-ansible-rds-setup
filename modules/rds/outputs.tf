output "endpoint" {
  value       = aws_db_instance.db_instance.endpoint
  description = "The endpoint of the RDS instance"
}

output "instance_id" {
  value       = aws_db_instance.db_instance.id
  description = "The ID of the RDS instance"
}

output "username" {
  value       = aws_db_instance.db_instance.username
  sensitive   = true
  description = "The username for the RDS instance"
}
