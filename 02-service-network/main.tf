locals {
  env = terraform.workspace
}

module "service_vpcs" {
  source      = "./modules/20-net-vpc"
  project_id  = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]

  name        = "${local.env}-${var.network_name}"
  subnets     = var.subnet_config
}

module "service_firewall" {
  source     = "./modules/21-net-vpc-firewall"
  project_id = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]

  network    = "${local.env}-${var.network_name}"

  depends_on = [module.service_vpcs]
}

module "service_nat" {
  source     = "./modules/22-net-cloudnat"
  project_id = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]

  region         = var.region
  name           = "${local.env}-nat"
  router_create  = true
  router_network = "${local.env}-${var.network_name}"

  depends_on = [module.service_vpcs]
}
