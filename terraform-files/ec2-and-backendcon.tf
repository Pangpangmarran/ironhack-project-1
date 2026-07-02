variable "project_name" {
  type    = string
  default = "annaas-project1"
}
variable "availability_zone" {
  type    = string
  default = "eu-central-1a"
}
variable "ec2_instances" {
  type = map(object({
    name          = string
    instance_type = string
  }))
  default = {
    frontend = {
      name          = "annaas-instance-frontend"
      instance_type = "t3.micro"
      Role          = "Frontend"
    }
    backend = {
      name          = "annaas-instance-backend"
      instance_type = "t3.micro"
      Role          = "Backend"
    }
    db = {
      name          = "annaas-instance-db"
      instance_type = "t3.micro"
      Role          = "DB"
    }
  }
}
resource "aws_instance" "ec2" {
  for_each      = var.ec2_instances
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = each.value.instance_type
  key_name      = var.key_pair_name
  tags = {
    Name       = each.value.name  
    Role       = each.key
  }
}
# The above ami is the Ubuntu image from AWS for eu-central-1
variable "state_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "annaas-terraform-state"
}
# Doing a remote terraform statefile in the s3 bucket, but no protection of lifecycle. This is not a permanent project.
variable "state_key" {
  description = "S3 key path for Terraform state"
  type        = string
  default     = "/home/annaa/devops-controled/week10/ironhack-project-1/backend-bootstrap/terraform.tfstate"
}

variable "state_region" {
  description = "AWS region for the S3 backend"
  type        = string
  default     = "eu-central-1"
}

variable "state_lock_table" {
  description = "DynamoDB table used for Terraform state locking"
  type        = string
  default     = "terraform-locks"
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main VPC"
  }
}