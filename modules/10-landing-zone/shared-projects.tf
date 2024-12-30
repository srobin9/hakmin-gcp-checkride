locals {
  common_folder_name = "Common"

  shared_project_configs = {
    "shared-vpc-prod" = {
      name                            = "shared-vpc-prod"
      folder_name                     = local.common_folder_name
      enable_shared_vpc_host_project  = true
      activate_apis = []
    }
    "shared-vpc-nonprod" = {
      name                            = "shared-vpc-nonprod"
      folder_name                     = local.common_folder_name
      enable_shared_vpc_host_project  = true
      activate_apis = []
    }
    "central-logging-monitoring" = {
      name                            = "central-logging-monitoring"
      folder_name                     = local.common_folder_name
      enable_shared_vpc_host_project  = false
      activate_apis = [
        "compute.googleapis.com",
        "monitoring.googleapis.com",
      ]
    }
  }
}

module "shared_project_module" {
  for_each = local.shared_project_configs

  source = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  name                            = each.value.name
#  project_id                      = "p-${formatdate("s", timeadd(timestamp(), "0h"))}-${substr(lower(replace(each.key, "/[^a-z0-9-]/", "")), 0, 25)}"
  project_id                      = "p-${var.prefix}-${substr(lower(replace(each.key, "/[^a-z0-9-]/", "")), 0, 15)}"
  org_id                          = var.org_id
  folder_id                       = local.folder_map[each.value.folder_name].id
  billing_account                 = var.billing_account
  enable_shared_vpc_host_project  = each.value.enable_shared_vpc_host_project
  activate_apis                   = each.value.activate_apis
}