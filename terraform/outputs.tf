output "web_server_public_ips" {
  description = "Public IPs of the web server instances"
  value       = module.ironhack_project_1.web_server_public_ip
}

output "web_server_private_ips" {
  description = "Private IPs of the web server instances"
  value       = module.ironhack_project_1.web_server_private_ip
}

output "web_server_ids" {
  description = "IDs of the web server instances"
  value       = module.ironhack_project_1.web_server_id
}
