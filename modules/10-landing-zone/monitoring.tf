resource "google_monitoring_monitored_project" "cs_monitored_projects" {
  for_each = merge(
    {
      for key, val in module.shared_project_module :
      key => val
      if key != "central-logging-monitoring"
    },
    {
      for key, val in module.service_project : key => val
    }
  )

  metrics_scope = "locations/global/metricsScopes/${module.shared_project_module["central-logging-monitoring"].project_id}"
  name          = each.value.project_id
}