resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

    enable_dns_support   = true
    enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
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
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true  
  # Automatically assign a public IP to instances launched in this subnet
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet"
  }
}
resource "aws_subnet" "private_db_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidr
  availability_zone = "eu-central-1c"

  tags = {
    Name = "private-db-subnet"
  }
}
# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "NAT-EIP"
  }
}

# Create NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id  # Ensure this is a public subnet

  tags = {
    Name = "NATGateway"
  }
}

# Create a route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "annaas-PrivateRouteTable"
  }
}
# Associate this route table with your private and DB subnets
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "db_subnet_association" {
  subnet_id      = aws_subnet.private_db_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}