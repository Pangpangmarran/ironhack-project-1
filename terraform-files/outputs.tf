output "vpc_name" {
  description = "VPC name"
  value       = var.vpc_name
}
output "instance_information" {
  description = "names and IPs of the created resources"
  value       = {
    name      = instance.tags["name"]
    private_ip= instance.private_ip
    Role      = instance.Role
  }
}