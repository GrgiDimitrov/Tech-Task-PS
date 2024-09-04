
variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "secret_source_arn" {
    description = "The arn of the secret"
  
}