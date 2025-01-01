locals {
  folder_iam_bindings = {
    "nonprod-computeinstanceAdminv1" = {
      folder_id = local.folder_map["Non-Production"].id
      role      = "roles/compute.instanceAdmin.v1"
      group     = "group:gcp-developers@${var.org_domain}"
    }
    "nonprod-containeradmin" = {
      folder_id = local.folder_map["Non-Production"].id
      role      = "roles/container.admin"
      group     = "group:gcp-developers@${var.org_domain}"
    }
    "dev-computeinstanceAdminv1" = {
      folder_id = local.folder_map["Development"].id
      role      = "roles/compute.instanceAdmin.v1"
      group     = "group:gcp-developers@${var.org_domain}"
    }
    "dev-containeradmin" = {
      folder_id = local.folder_map["Development"].id
      role      = "roles/container.admin"
      group     = "group:gcp-developers@${var.org_domain}"
    }
  }
}

module "cs-folders-iam" {
  for_each = local.folder_iam_bindings

  source = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.7"

  folders = [each.value.folder_id]
  bindings = {
    (each.value.role) = [each.value.group]
  }
}

locals {
  logging_monitoring_project_id = module.shared_project_module["central-logging-monitoring"].project_id

  project_iam_bindings = {
    "logging-monitoring-loggingviewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/logging.viewer"
      group      = "group:gcp-logging-monitoring-viewers@${var.org_domain}"
    }
    "logging-monitoring-loggingprivateLogViewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/logging.privateLogViewer"
      group      = "group:gcp-logging-monitoring-viewers@${var.org_domain}"
    }
    "logging-monitoring-bigquerydataViewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/bigquery.dataViewer"
      group      = "group:gcp-logging-monitoring-viewers@${var.org_domain}"
    }
    "logging-monitoring-pubsubviewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/pubsub.viewer"
      group      = "group:gcp-logging-monitoring-viewers@${var.org_domain}"
    }
    "logging-monitoring-monitoringviewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/monitoring.viewer"
      group      = "group:gcp-logging-monitoring-viewers@${var.org_domain}"
    }
    "security-admins-bigquerydataViewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/bigquery.dataViewer"
      group      = "group:gcp-security-admins@${var.org_domain}"
    }
    "security-admins-pubsubviewer" = {
      project_id = local.logging_monitoring_project_id
      role       = "roles/pubsub.viewer"
      group      = "group:gcp-security-admins@${var.org_domain}"
    }
  }
}

module "cs-projects-iam" {
  for_each = local.project_iam_bindings

  source = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"

  projects = [each.value.project_id]
  bindings = {
    (each.value.role) = [each.value.group]
  }
}