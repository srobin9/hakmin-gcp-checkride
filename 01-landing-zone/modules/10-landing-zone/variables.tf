variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "folders" {
  description = "Folder structure as a map"
  type        = map
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "prefix" {
  description = "The prefix to create project_id" 
  type        = string
  default     = "01ADFE-044C15-B43759"
}

variable "directory_customer_id" {
  description = "The organization directory customer id for the associated resources"
  type        = string
}

variable "org_domain" {
  description = "The organization domain for the associated resources"
  type        = string
}

variable "groups" {
  description = "Group structure as a map"
  type = map(object({
    id          = string
    display_name = string
    types        = list(string)
  }))
}

variable "shared_vpcs" {
  type = map(object({
    network_name = string
    subnets      = list(object({
      subnet_name               = string
      subnet_ip                 = string
      subnet_region             = string
      subnet_private_access     = bool
      subnet_flow_logs          = bool
      subnet_flow_logs_sampling = string
      subnet_flow_logs_metadata = string
      subnet_flow_logs_interval = string
    }))
  }))
}

variable "shared_firewall_rules" {
  type = list(object({
    name      = string
    direction = string
    priority  = number
    allow     = list(object({
      protocol = string
      ports    = list(string)
    }))
    ranges = list(string)
  }))
}

variable "service_projects" {
  description = "Workload projects except common project"
  type = map(object({
    name            = string
    folder_name     = string
    shared_vpc_key  = string
    group_key       = string
  }))
}

/**
variable "service_project_folder_names" {
  description = "Folder names for the service projects"
  type        = map(string)
}

variable "billing_project" {
  description = "The project id to use for billing"
  type        = string
}
**/