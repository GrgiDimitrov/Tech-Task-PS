
variable "secret_name" {
  description = "The name of the secret in Secrets Manager"
  type        = string
}

variable "master_username" {
  description = "The master username for the database"
  type        = string
}

variable "master_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

variable "rotation_lambda_arn" {
  description = "The ARN of the Lambda function used for rotating the secret"
  type        = string
}

variable "rotation_interval" {
  description = "The number of days after which to automatically rotate the secret"
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}