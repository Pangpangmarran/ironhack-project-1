variable "bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "annaas-terraform-state"
}

variable "region" {
  description = "AWS region to create backend resources in"
  type        = string
  default     = "eu-central-1"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locks"
  type        = string
  default     = "annaas-terraform-locks"
}
