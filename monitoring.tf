resource "google_monitoring_monitored_project" "cs-monitored-projects" {
  for_each = toset([
    module.cs-project-vpc-host-prod.project_id,
    module.cs-project-vpc-host-nonprod.project_id,
    module.cs-svc-prod1-svc-6hy1.project_id,
    module.cs-svc-prod2-svc-6hy1.project_id,
    module.cs-svc-nonprod1-svc-6hy1.project_id,
    module.cs-svc-nonprod2-svc-6hy1.project_id,
  ])
  metrics_scope = "locations/global/metricsScopes/${module.cs-project-logging-monitoring.project_id}"
  name          = each.value
}
