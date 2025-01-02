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

variable "project_name" {
  type = string
}

variable "region" {
  description = "Region for resources"
  type        = string
  default     = "asia-northeast3" # 기본 리전 설정
}
variable "database_version" {
  description = "Database type and version"
  type        = string
  default     = "MYSQL_8_0" # "POSTGRES_13"
}

variable "tier" {
  description = "Database Instance Tier"
  type        = string
  default     = "db-g1-small"
}

variable "gcp_deletion_protection" {
  description = "Set Google's deletion protection attribute which applies across all surfaces"
  type        = bool
  default     = false
}

variable "terraform_deletion_protection" {
  description = "Prevent terraform from deleting instances."
  type        = bool
  default     = false
}