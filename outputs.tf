output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "The endpoint of the RDS instance"
}

output "rds_instance_id" {
  value       = module.rds.instance_id
  description = "The ID of the RDS instance"
}

output "rds_username" {
  value       = module.rds.username
  sensitive   = true
  description = "The username for the RDS instance"
}
