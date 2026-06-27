terraform {
  backend "s3" {
    bucket         = "annaas-terraform-state"
    key            = "project1/terraform.tfstate" # Path inside the S3 bucket
    region         = "eu-central-1"
    dynamodb_table = "annaas-terraform-locks"
    encrypt        = true
  }
}
