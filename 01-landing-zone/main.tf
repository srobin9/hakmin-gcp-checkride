module "landing_zone" {
  source                = "./modules/10-landing-zone"
  folders               = var.folders
  org_id                = var.org_id
  billing_account       = var.billing_account
  prefix                = var.prefix
  directory_customer_id = data.google_organization.org.directory_customer_id
  org_domain            = data.google_organization.org.domain
  groups                = var.groups
  shared_vpcs           = var.shared_vpcs
  shared_firewall_rules = var.shared_firewall_rules # 변수 사용 또는 삭제
  service_projects      = var.service_projects
}

module "service_project_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 16.0"

  for_each = var.service_projects

  project_id = module.landing_zone.project_ids_by_name[each.value.name]

  activate_apis = [
    "container.googleapis.com", # Kubernetes Engine API
  ]

  disable_dependent_services = true
  disable_services_on_destroy = false

  depends_on = [module.landing_zone]

}