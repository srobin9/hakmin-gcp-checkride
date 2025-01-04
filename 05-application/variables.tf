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

variable "gke_gateway" {
  description = "gke gateway configurations"
  type = map(string)
  default = {
    gateway_name      = "http-external"
    gateway_namespace = "gke-gateway-namespace"
    app_namespace     = "default"
  #  tls_secret_name   = ""
  }
}