output "project_ids_by_name" {
  description = "A map from project names to project IDs, for shared projects."
  value = module.landing_zone.project_ids_by_name
}

output "project_numbers_by_name" {
  description = "A map from project names to project NUMBERs, for shared projects."
  value = module.landing_zone.project_numbers_by_name
}