module "service_project" {
  for_each = var.service_projects

  source = "terraform-google-modules/project-factory/google//modules/svpc_service_project"
  version = "~> 16.0"

  name            = each.value.name
#  project_id      = "p-${formatdate("s", timeadd(timestamp(), "0h"))}-${substr(lower(replace(each.key, "/[^a-z0-9-]/", "")), 0, 25)}"
  project_id      = "p-${var.prefix}-${substr(lower(replace(each.key, "/[^a-z0-9-]/", "")), 0, 15)}"
  org_id          = var.org_id
  billing_account = var.billing_account
  folder_id       = local.folder_map[each.value.folder_name].id

  shared_vpc = module.shared_project_module[each.value.shared_vpc_key].project_id
 # shared_vpc_subnets = [
 #   try(module.shared_vpcs.subnets[each.value.subnet_key].self_link, ""),
 # ]

  domain      = var.org_domain
  group_name  = module.cs-gg-service[each.value.group_key].name
  group_role  = "roles/viewer"
}