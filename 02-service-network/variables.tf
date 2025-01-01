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

variable "project_name" {
  description = "Workload project name"
  type = string
}

variable "network_name" {
  description = "VPC network name"
  type = string
}

variable "subnet_config" {
  description = "Subnet configurations"
  type = list(object({
    name                = string
    ip_cidr_range       = string
    region              = string
    secondary_ip_ranges = optional(map(string))
    flow_logs_config    = optional(object({
      flow_sampling         = number
      aggregation_interval  = string
    }))
  }))
}