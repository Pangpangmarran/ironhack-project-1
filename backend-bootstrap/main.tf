terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_s3_bucket" "state" {
  bucket = var.bucket
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = data.aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = data.aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
data "aws_dynamodb_table" "locks" {
  name = var.dynamodb_table_name
}
resource "aws_dynamodb_table" "locks" {
  name     = "annaas-terraform-locks"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}
