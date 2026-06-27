output "bucket_name" {
  description = "Name of the S3 bucket created for Terraform state"
  value       = aws_s3_bucket.state.bucket
}

output "dynamodb_table" {
  description = "Name of the DynamoDB table created for Terraform locks"
  value       = aws_dynamodb_table.locks.name
}
