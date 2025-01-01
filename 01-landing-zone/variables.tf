variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
  default     = "01ADFE-044C15-B43759"
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
  default     = "497314095400"
}

variable "billing_project" {
  description = "The project id to use for billing"
  type        = string
  default     = "cs-host-b0532598bd5c475e8d3843"
}

variable "user_project_override" {
  description = "Whether to use user project override for the providers"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region for resources"
  type = string
  default = "asia-northeast3" # 기본 리전 설정
}

variable "prefix" {
  description = "The prefix to create project_id" 
  type        = string
  default     = "01ADFE-044C15-B43759"
}

variable "folders" {
  description = "Folder structure as a map"
  type        = map
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