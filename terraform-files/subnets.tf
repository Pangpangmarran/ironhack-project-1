
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  // Example CIDR block for the VPC
  tags = {
    Name = var.vpc_name
  }
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
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-central-1"
  map_public_ip_on_launch = true  // Automatically assign a public IP to instances launched in this subnet

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "<your-availability-zone>"

  tags = {
    Name = "private-subnet"
  }
}
resource "aws_subnet" "private_db_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidr
  availability_zone = "<your-availability-zone>"

  tags = {
    Name = "private-db-subnet"
  }
}
