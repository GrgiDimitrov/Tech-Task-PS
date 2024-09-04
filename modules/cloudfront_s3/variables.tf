
variable "vpc_id" {
  description = "The VPC ID where the load balancer and target groups will be deployed"
  type        = string
}


variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "The origin ID for the CloudFront distribution"
  type        = string
}
variable "alb_dns_name" {
  description = "The DNS name of the Aplication Load Balancer"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}