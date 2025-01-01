locals {
  env = terraform.workspace
}

module "service_vpcs" {
  source     = "./modules/20-net-vpc"
  for_each   = { for idx, val in var.subnet_config : idx => val } # for_each 추가, 인덱스를 키로 사용

  project_id = var.project_id
  name       = "${local.env}-${var.network_name}"

  subnets = [
    {
      name                  = each.value.subnet_name
      ip_cidr_range         = each.value.subnet_ip
      region                = each.value.subnet_region
      secondary_ip_ranges   = each.value.secondary_ip_ranges
      flow_logs_config      = each.value.flow_logs_config
    }
  ]
}

module "service_firewall" {
  source     = "./modules/21-net-vpc-firewall"

  project_id = var.project_id
  network    = "${local.env}-${var.network_name}"

  depends_on = [module.service_vpcs]
}

module "service_nat" {
  source     = "./modules/22-net-cloudnat"

  project_id = var.project_id

  region         = var.region
  name           = "${local.env}-nat"
  router_create  = true
  router_network = var.network_name

  depends_on = [module.service_vpcs]
}
