# modules/1-landing-zone/outputs.tf

output "project_ids_by_name" {
  description = "A map from project names to project IDs, for shared projects."
  value = {
    for key, project in module.service_project : project.project_name => project.project_id
  }
}