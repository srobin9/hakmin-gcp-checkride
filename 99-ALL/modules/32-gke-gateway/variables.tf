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

variable "k8s_host" {
  description = "GKE 클러스터 엔드포인트"
  type = string
}

variable "k8s_token" {
  description = "GKE 클러스터 인증 토큰"
  type = string
}

variable "k8s_ca_certificate" {
  description = "GKE 클러스터 CA 인증서"
  type = string
}

/**
variable "tls_secret_name" {
  description = "Name of the Kubernetes secret containing the TLS certificate"
  type = string
}
**/