output "id" {
  description = "Fully qualified network id."
  value       = module.service_vpcs.id
}

output "internal_ipv6_range" {
  description = "ULA range."
  value       = module.service_vpcs.internal_ipv6_range
}

output "name" {
  description = "Network name."
  value       = module.service_vpcs.name
}

output "network" {
  description = "Network resource."
  value       = module.service_vpcs.network
}

output "network_attachment_ids" {
  description = "IDs of network attachments."
  value = module.service_vpcs.network_attachment_ids
}

output "project_id" {
  description = "Project ID containing the network. Use this when you need to create resources *after* the VPC is fully set up (e.g. subnets created, shared VPC service projects attached, Private Service Networking configured)."
  value       = module.service_vpcs.project_id
}

output "self_link" {
  description = "Network self link."
  value       = module.service_vpcs.self_link
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by name."
  value       = module.service_vpcs.subnet_ids
}

output "subnet_ips" {
  description = "Map of subnet address ranges keyed by name."
  value = module.service_vpcs.subnet_ips
}

output "subnet_ipv6_external_prefixes" {
  description = "Map of subnet external IPv6 prefixes keyed by name."
  value = module.service_vpcs.subnet_ipv6_external_prefixes
}

output "subnet_regions" {
  description = "Map of subnet regions keyed by name."
  value = module.service_vpcs.subnet_regions
}

output "subnet_secondary_ranges" {
  description = "Map of subnet secondary ranges keyed by name."
  value = module.service_vpcs.subnet_secondary_ranges
}

output "subnet_self_links" {
  description = "Map of subnet self links keyed by name."
  value       = module.service_vpcs.subnet_self_links
}

output "subnets" {
  description = "Subnet resources."
  value       = module.service_vpcs.subnets
}

output "subnets_private_nat" {
  description = "Private NAT subnet resources."
  value       = module.service_vpcs.subnets_private_nat
}

output "subnets_proxy_only" {
  description = "L7 ILB or L7 Regional LB subnet resources."
  value       = module.service_vpcs.subnets_proxy_only
}

output "subnets_psc" {
  description = "Private Service Connect subnet resources."
  value       = module.service_vpcs.subnets_psc
}
