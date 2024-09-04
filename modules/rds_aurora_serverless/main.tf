
resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  storage_encrypted       = var.storage_encrypted
  deletion_protection     = var.deletion_protection
  final_snapshot_identifier = "${var.cluster_identifier}-snapshot"
  skip_final_snapshot = false
  

  scaling_configuration {
    auto_pause               = var.auto_pause
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
  }

  tags = var.tags
}

# Create a DB subnet group for the Aurora cluster
resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

