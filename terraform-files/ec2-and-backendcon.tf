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
resource "aws_instance" "ec2" {
  for_each      = var.ec2_instances
  ami           = "ami-0303e2e4a29f041a3"
  instance_type = each.value.instance_type
  key_name      = var.key_pair_name
  # The above ami is the Ubuntu image from AWS for eu-central-1
  subnet_id = lookup(
    {
      frontend = aws_subnet.public_subnet.id       // Use public subnet for frontend
      backend  = aws_subnet.private_subnet.id      // Use private subnet for backend
      db       = aws_subnet.private_db_subnet.id 
    },
    each.key,
    aws_subnet.private_db_subnet.id
  )

  vpc_security_group_ids = [
    lookup(
      {
        frontend = aws_security_group.frontend_sg.id
        backend  = aws_security_group.backend_sg.id
        db       = aws_security_group.backend_sg.id
      },
      each.key,
      aws_security_group.backend_sg.id
    )
  ]

  tags = {
    Name = each.value.name
    Role = each.key
  }
}
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
