variable "region" { default = "us-east-1" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "db_name" { default = "medusa" }
variable "db_username" { default = "admin" }
variable "db_password" {
  type      = string
  sensitive = true
}
