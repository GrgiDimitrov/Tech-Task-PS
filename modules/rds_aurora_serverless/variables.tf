variable "environment" {
    description = "Environment variable"
    type = string
}

variable "cluster_identifier" {
  description = "The cluster identifier for the RDS Aurora instance"
  type        = string
}

variable "database_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "mydb"
}

variable "master_username" {
  description = "The master username for the RDS instance"
  type        = string
}

variable "master_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "01:00-02:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
  type        = string
  default     = "sun:03:00-sun:04:00"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the RDS cluster"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the RDS cluster"
  type        = list(string)
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB cluster should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "auto_pause" {
  description = "Whether to enable auto-pause for the Aurora Serverless DB cluster"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "The minimum capacity for an Aurora Serverless DB cluster"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "The maximum capacity for an Aurora Serverless DB cluster"
  type        = number
  default     = 8
}

variable "seconds_until_auto_pause" {
  description = "The time, in seconds, before an Aurora Serverless DB cluster auto-pauses"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}