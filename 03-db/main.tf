locals {
  env = terraform.workspace
}

module "alloydb" {
  source         = "./fabric/modules/alloydb"
  project_id     = module.project.project_id
  project_number = var.project_number
  cluster_name   = "db"
  network_config = {
    psa_config = {
      network = module.vpc.id
    }
  }
  instance_name = "db"
  location      = var.region
}
# tftest modules=3 resources=16 inventory=simple.yaml e2e

/**
module "cloudsql" {
  source     = "./fabric/modules/cloudsql-instance"
  project_id = module.project.project_id
  network_config = {
    connectivity = {
      psa_config = {
        private_network = module.vpc.self_link
      }
      # psc_allowed_consumer_projects = [var.project_id]
    }
  }
  name                          = "db"
  region                        = var.region
  database_version              = "POSTGRES_13"
  tier                          = "db-g1-small"
  gcp_deletion_protection       = false
  terraform_deletion_protection = false
}
**/