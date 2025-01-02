# outputs.tf (루트 모듈)

output "alloydb_id" {
  description = "Fully qualified primary instance id."
  value       = module.alloydb.id
}

output "alloydb_ids" {
  description = "Fully qualified ids of all instances."
  value = module.alloydb.ids
}

output "alloydb_instances" {
  description = "AlloyDB instance resources."
  value       = module.alloydb.instances
  sensitive   = true
}

output "alloydb_ip" {
  description = "IP address of the primary instance."
  value       = module.alloydb.ip
}

output "alloydb_ips" {
  description = "IP addresses of all instances."
  value = module.alloydb.ips
}

output "alloydb_name" {
  description = "Name of the primary instance."
  value       = module.alloydb.name
}

output "alloydb_names" {
  description = "Names of all instances."
  value = module.alloydb.names
}

output "alloydb_psc_dns_name" {
  description = "AlloyDB Primary instance PSC DNS name."
  value       = module.alloydb.psc_dns_name
}

output "alloydb_psc_dns_names" {
  description = "AlloyDB instances PSC DNS names."
  value = module.alloydb.psc_dns_names
}

output "alloydb_user_passwords" {
  description = "Map of containing the password of all users created through terraform."
  value = module.alloydb.user_passwords
  sensitive = true
}

/**
output "cloudsql_client_certificates" {
  description = "The CA Certificate used to connect to the SQL Instance via SSL."
  value       = module.cloudsql.client_certificates
  sensitive   = true
}

output "cloudsql_connection_name" {
  description = "Connection name of the primary instance."
  value       = module.cloudsql.connection_name
}

output "cloudsql_connection_names" {
  description = "Connection names of all instances."
  value = module.cloudsql.connection_names
}

output "cloudsql_dns_name" {
  description = "The dns name of the instance."
  value       = module.cloudsql.dns_name
}

output "cloudsql_dns_names" {
  description = "Dns names of all instances."
  value = module.cloudsql.dns_names
}

output "cloudsql_id" {
  description = "Fully qualified primary instance id."
  value       = module.cloudsql.id
}

output "cloudsql_ids" {
  description = "Fully qualified ids of all instances."
  value = module.cloudsql.ids
}

output "cloudsql_instances" {
  description = "Cloud SQL instance resources."
  value       = module.cloudsql.instances
  sensitive   = true
}

output "cloudsql_ip" {
  description = "IP address of the primary instance."
  value       = module.cloudsql.ip
}

output "cloudsql_ips" {
  description = "IP addresses of all instances."
  value = module.cloudsql.ips
}

output "cloudsql_name" {
  description = "Name of the primary instance."
  value       = module.cloudsql.name
}

output "cloudsql_names" {
  description = "Names of all instances."
  value = module.cloudsql.names
}

output "cloudsql_psc_service_attachment_link" {
  description = "The link to service attachment of PSC instance."
  value       = module.cloudsql.psc_service_attachment_link
}

output "cloudsql_psc_service_attachment_links" {
  description = "Links to service attachment of PSC instances."
  value = module.cloudsql.psc_service_attachment_links
}

output "cloudsql_self_link" {
  description = "Self link of the primary instance."
  value       = module.cloudsql.self_link
}

output "cloudsql_self_links" {
  description = "Self links of all instances."
  value = module.cloudsql.self_links
}

output "cloudsql_user_passwords" {
  description = "Map of containing the password of all users created through terraform."
  value = module.cloudsql.user_passwords
  sensitive = true
}
**/