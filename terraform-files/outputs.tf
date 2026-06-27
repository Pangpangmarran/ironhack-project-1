output "public_subnet_cidr" {
  description = "Public IPs of the web server instances"
  value       = var.public_subnet_cidr
}

output "private_subnet_cidr" {
  description = "Private IPs of the web server instances"
  value       = var.private_subnet_cidr
}

output "vpc_cidr" {
  description = "VPC cidr"
  value       = var.vpc_cidr
}

output "vpc_name" {
  description = "VPC name"
  value       = var.vpc_name
}
output "web_server_public_ips" {
  description = "Public IPs of the web server instances"
  value       = aws_instance.web_server[*].public_ip
}

output "web_server_private_ips" {
  description = "Private IPs of the web server instances"
  value       = aws_instance.web_server[*].private_ip
}