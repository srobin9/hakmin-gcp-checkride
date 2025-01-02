locals {
  env = terraform.workspace
}


resource "google_project_service" "service_networking_api" {
  project = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false # API를 실수로 비활성화하는 것을 방지
}

module "alloydb" {
  source         = "./modules/30-alloydb"
  project_id     = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  project_number = data.terraform_remote_state.landing_zone.outputs.project_numbers_by_name[var.project_name]
  cluster_name   = "${local.env}-alloydb-cluster"
  ip_range_name   = var.alloydb_ip_range_name
  ip_prefix_length = var.alloydb_ip_prefix_length
  network_config = {
    psa_config = {
      network = data.terraform_remote_state.service_network.outputs.vpc_ids
    }
  }
  instance_name = "${local.env}-alloydb-intance"
  location      = var.region

  depends_on = [google_project_service.service_networking_api]
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

  depends_on = [google_project_service.service_networking_api]
}
**/