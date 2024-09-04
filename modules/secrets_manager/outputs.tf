
output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.db_master_credentials.arn
}

output "secret_name" {
  description = "The name of the secret"
  value       = aws_secretsmanager_secret.db_master_credentials.name
}

output "secret_version_id" {
  description = "The ID of the secret version"
  value       = aws_secretsmanager_secret_version.db_master_credentials_version.version_id
}