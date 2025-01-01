# VPC and Subnets
module "shared_vpcs" {
  for_each = var.shared_vpcs
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id    = module.shared_project_module[each.value.network_name].project_id
  network_name  = each.value.network_name
  subnets       = each.value.subnets
  firewall_rules = [for rule in var.shared_firewall_rules : {
    name = "${each.key}-${rule.name}-${rule.allow[0].protocol}" # each.key (VPC 이름) 과 인덱스 추가
    direction = rule.direction
    priority  = rule.priority
    allow     = rule.allow
    ranges    = rule.ranges 
    log_config  = {
      metadata  = "INCLUDE_ALL_METADATA"
    }
  }]
}
