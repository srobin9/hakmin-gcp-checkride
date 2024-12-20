module "cs-project-vpc-host-prod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  name       = "vpc-host-prod"
  project_id = "vpc-host-prod-lt115-ha667"
  org_id     = var.org_id
  folder_id  = local.folder_map["Common"].id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "cs-project-vpc-host-nonprod" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  name       = "vpc-host-nonprod"
  project_id = "vpc-host-nonprod-zp427-bm725"
  org_id     = var.org_id
  folder_id  = local.folder_map["Common"].id

  billing_account                = var.billing_account
  enable_shared_vpc_host_project = true
}

module "cs-project-logging-monitoring" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  name       = "central-logging-monitoring"
  project_id = "central-log-monitor-zr224-qf11"
  org_id     = var.org_id
  folder_id  = local.folder_map["Common"].id

  billing_account = var.billing_account
  activate_apis = [
    "compute.googleapis.com",
    "monitoring.googleapis.com",
  ]
}
