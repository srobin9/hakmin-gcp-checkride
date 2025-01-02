locals {
  env = terraform.workspace
}

module "alloydb" {
  source         = "./modules/30-alloydb"
  project_id     = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  project_number = data.terraform_remote_state.landing_zone.outputs.project_numbers_by_name[var.project_name]
  cluster_name   = "${local.env}-alloydb-cluster"
  network_config = {
    psa_config = {
      network = data.terraform_remote_state.service_network.outputs.vpc_ids
    }
  }
  instance_name = "${local.env}-alloydb-intance"
  location      = var.region
}
# tftest modules=3 resources=16 inventory=simple.yaml e2e

/**
module "cloudsql" {
  source     = "./modules/31-cloudsql-instance"
  project_id = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  network_config = {
    connectivity = {
      psa_config = {
        private_network = data.terraform_remote_state.service_network.outputs.vpc_self_links
      }
      # psc_allowed_consumer_projects = [data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]]
    }
  }
  name                          = "${local.env}-cloudsql"
  region                        = var.region
  database_version              = var.database_version
  tier                          = var.tier
  gcp_deletion_protection       = var.gcp_deletion_protection
  terraform_deletion_protection = var.terraform_deletion_protection
}
**/