variable "alb_name" {
  description = "The name of the application load balancer."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to attach to the ALB."
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "docker_image" {
  description = "The Docker image to deploy."
  type        = string
  default     = "181349251474.dkr.ecr.eu-west-1.amazonaws.com/simple-restful-container" 
}

variable "container_port" {
  description = "The port on which the container listens."
  type        = number
}


variable "desired_count" {
  description = "The desired number of tasks to run."
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "alb_security_group_id" {
  description = "List of Security Group IDs to attach to the ALB."
  type        = list(string)
}