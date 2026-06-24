variable "project_name" {
  type    = string
  default = "annaas-project1"
}
variable "vpc_name" {
  type    = string
  default = "annaas-VPC"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
variable "private_db_subnet_cidr" {
  type    = string
  default = "10.0.4.0/24"
}
