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

variable "helm_jenkins" {
  description = "Helm Jenkins configurations"
  type = object({
    chart_version     = string
    ingress_enabled   = bool
    ingress_host_name = string
    admin_user        = string
    admin_password    = string
  })
}

variable "helm_argocd" {
  description = "Helm ArgoCD configurations"
  type = object({
    chart_version       = string
  })
}

variable "helm_wordpress" {
  description = "Helm Wordpress configurations"
  type = object({
    admin_user        = string
    admin_password    = string
    db_password       = string
  })
}