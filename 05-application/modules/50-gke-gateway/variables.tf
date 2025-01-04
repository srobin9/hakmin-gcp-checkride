variable "gateway_name" {
  description = "GKE gateway name"
  type = string
  default = "gke-gateway-name"
}

variable "gateway_namespace" {
  description = "GKE gateway namespace"
  type = string
  default = "gke-gateway-namespace"
}

variable "app_namespace" {
  type    = string
  default = "default"
}

/**
variable "tls_secret_name" {
  description = "Name of the Kubernetes secret containing the TLS certificate"
  type = string
}
**/