variable "project_name" {
  type    = string
  default = "annaas-project1"
}
variable "availability_zone" {
  type    = string
  default = "eu-central-1a"
}
variable "ami_id" {
  type    = string
  default = "ami-036bdae36143a955f"
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
    }
    backend = {
      name          = "annaas-instance-backend"
      instance_type = "t3.micro"
    }
    db = {
      name          = "annaas-instance-db"
      instance_type = "t3.micro"
    }
  }
}
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

variable "state_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "annaas-terraform-state"
}
# Doing a remote terraform statefile in the s3 bucket, but no protection of lifecycle. This is not a permanent project.
variable "state_key" {
  description = "S3 key path for Terraform state"
  type        = string
  default     = "project1/terraform.tfstate"
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