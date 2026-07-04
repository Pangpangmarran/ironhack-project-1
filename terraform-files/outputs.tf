output "vpc_name" {
  description = "VPC name"
  value       = var.vpc_name
}
output "instance_information" {
  description = "names and IPs of the created resources"
  value = {
    for instance_key, instance_resource in aws_instance.ec2 : instance_key => {
      name       = instance_resource.tags["Name"]
      private_ip = instance_resource.private_ip
      Role       = instance_resource.tags["Role"]
    }
  }
}