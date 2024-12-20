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

variable "folders" {
  description = "Folder structure as a map"
  type        = map
}
