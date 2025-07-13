variable "region" {}
variable "vpc_cidr" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "image_tag" {
  description = "Docker image tag for ECS"
  type        = string
  default     = "latest"
}

