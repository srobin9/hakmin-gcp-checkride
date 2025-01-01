locals {
  org_policies = {
    "storage_publicAccessPrevention" = {
      constraint = "storage.publicAccessPrevention"
    }
    "sql_restrictPublicIp" = {
      constraint = "sql.restrictPublicIp"
    }
    "compute_restrictXpnProjectLienRemoval" = {
      constraint = "compute.restrictXpnProjectLienRemoval"
    }
    "compute_disableVpcExternalIpv6" = {
      constraint = "compute.disableVpcExternalIpv6"
    }
  }
}

module "org_policy" {
  for_each = local.org_policies

  source = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "~> 5.2"

  policy_root      = "organization"
  policy_root_id   = var.org_id
  constraint       = each.value.constraint
  policy_type      = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      enforcement = true
      allow       = []
      deny        = []
      conditions  = []
    },
  ]
}