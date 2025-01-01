# random suffix to prevent collisions
resource "random_id" "suffix" {
  byte_length = 4
}

module "cs-logsink-logbucketsink" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 8.0"

  destination_uri      = module.cs-logging-destination.destination_uri
  log_sink_name        = "${var.org_id}-logbucketsink-${random_id.suffix.hex}"
  parent_resource_id   = var.org_id
  parent_resource_type = "organization"
  include_children     = true
  filter               = "logName: /logs/cloudaudit.googleapis.com%2Factivity OR logName: /logs/cloudaudit.googleapis.com%2Fsystem_event OR logName: /logs/cloudaudit.googleapis.com%2Fdata_access OR logName: /logs/cloudaudit.googleapis.com%2Faccess_transparency"
}

module "cs-logging-destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 8.0"

  project_id               = module.shared_project_module["central-logging-monitoring"].project_id
  name                     = "kimhakmin.altostrat-logging"
  location                 = "global"
  retention_days           = 30
  log_sink_writer_identity = module.cs-logsink-logbucketsink.writer_identity
}
