# In order to create google groups, the calling identity should have at least the
# Group Admin role in Google Admin. More info: https://support.google.com/a/answer/2405986

module "cs-gg-service" {
  for_each = var.groups

  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id            = each.value.id
  display_name  = each.value.display_name
  customer_id   = var.directory_customer_id
  types         = each.value.types
}