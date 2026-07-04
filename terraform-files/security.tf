variable "admin_cidr" {
  type        = string
  description = "Your IP for SSH access"
  default     = "85.49.195.61/32"
}
variable "key_pair_name" {
  description = "Name of the EC2 Key Pair to use"
  type        = string
  default     = "annaas-key"
}
# Key pair is added to my AWS and tested
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
# Frontend security group: web server access and SSH administration
resource "aws_security_group" "frontend_sg" {
  name        = "annaa-frontend-sg"
  description = "Allow HTTP and SSH access for frontend instances"
  vpc_id      = aws_vpc.main.id

  # HTTP ingress: allow public web traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH ingress: allow remote administration
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Backend security group: internal database and cache access only
resource "aws_security_group" "backend_sg" {
  name   = "annaa-backend-sg"
  vpc_id = aws_vpc.main.id

  # PostgreSQL ingress allowed only from VPC CIDR
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Redis ingress allowed only from VPC CIDR
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Egress: allow backend instances to make outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VPC endpoint security group: secure SSM communication
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "annaa-vpc-endpoint-sg"
  description = "Security group for VPC endpoints (SSM)"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS inbound from VPC CIDR (required for SSM endpoints)
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}