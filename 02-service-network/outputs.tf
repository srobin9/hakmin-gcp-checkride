# VPC
output "vpc_names" {
  description   = "Names of the VPC networks"
  value         = module.service_vpcs.name
}

output "vpc_ids" {
  description   = "IDs of the VPC networks"
  value         = module.service_vpcs.id
}

output "vpc_self_links" {
  description   = "Self links of the VPC networks"
  value         = module.service_vpcs.self_link
}

output "project_id" {
  description   = "Self links of the VPC networks"
  value         = module.service_vpcs.project_id
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by name."
  value         = module.service_vpcs.subnet_ids
}

output "subnet_self_links" {
  description = "Map of subnet IDs keyed by name."
  value         = module.service_vpcs.subnet_self_links
}

output "subnet_regions" {
  description = "Map of subnet address ranges keyed by name."
  value         = module.service_vpcs.subnet_regions
}

output "subnet_ips" {
  description = "Map of subnet address ranges keyed by name."
  value         = module.service_vpcs.subnet_ips
}

/**
output "service_vpcs" {
  description = "Map of subnet regions keyed by name."
  value         = module.service_vpcs
}
**/