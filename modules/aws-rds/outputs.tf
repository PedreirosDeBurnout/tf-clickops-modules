output "rds_host" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.rds.address
}

output "rds_name" {
  description = "The database name"
  value       = aws_db_instance.rds.db_name
}

output "rds_user" {
  description = "The database user"
  value       = aws_db_instance.rds.username
}

output "rds_password" {
  description = "The database password"
  sensitive   = true
  value       = data.aws_secretsmanager_secret_version.rds_password.secret_string
}

output "rds_port" {
  description = "The database port"
  value       = aws_db_instance.rds.port
}
