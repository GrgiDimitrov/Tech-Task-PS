
resource "aws_secretsmanager_secret" "db_master_credentials" {
  name        = var.secret_name
  description = "Master credentials for the RDS PostgreSQL database"

  tags = var.tags
}


resource "aws_secretsmanager_secret_version" "db_master_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_master_credentials.id
  secret_string = jsonencode({
    username = var.master_username
    password = var.master_password
  })

  depends_on = [aws_secretsmanager_secret.db_master_credentials]
}

# Enable rotation for the secret
resource "aws_secretsmanager_secret_rotation" "db_master_credentials_rotation" {
  secret_id     = aws_secretsmanager_secret.db_master_credentials.id
  rotation_lambda_arn = var.rotation_lambda_arn
  rotation_rules {
    automatically_after_days = var.rotation_interval
  }

  depends_on = [aws_secretsmanager_secret_version.db_master_credentials_version]
}

resource "aws_iam_policy" "rds_secrets_policy" {
  name        = "dev-rds-access-policy"
  description = "Policy to allow RDS to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = aws_secretsmanager_secret.db_master_credentials.arn
      }
    ]
  })

  tags = var.tags
}