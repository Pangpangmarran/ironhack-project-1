provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}

module "ironhack_project_1" {
  source = "./ironhack-project-1"

  project_name           = var.project_name
  vpc_cidr               = var.vpc_cidr
  vpc_name               = var.vpc_name
  public_subnet_cidr     = var.public_subnet_cidr
  private_subnet_cidr    = var.private_subnet_cidr
  private_db_subnet_cidr = var.private_db_subnet_cidr
  availability_zone      = var.availability_zone
  ami_id                 = var.ami_id
  ec2_instances          = var.ec2_instances
  admin_cidr             = var.admin_cidr
  key_pair_name          = var.key_pair_name

}
