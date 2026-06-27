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

