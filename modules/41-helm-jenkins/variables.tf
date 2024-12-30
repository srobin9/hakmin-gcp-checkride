# modules/jenkins-helm/variables.tf

variable "release_name" {
  description = "Jenkins Helm release name"
  type        = string
  default     = "jenkins"
}

variable "repository" {
  description = "Jenkins Helm chart repository"
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "chart" {
  description = "Jenkins Helm chart name"
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Jenkins Helm chart version"
  type        = string
  default     = "5.7.26" # 필요에 따라 최신 버전으로 업데이트
}

variable "namespace" {
  description = "Kubernetes namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "service_type" {
  description = "Jenkins controller service type"
  type = string
  default = "LoadBalancer"
}

variable "ingress_enabled" {
  description = "Enable Ingress for Jenkins"
  type = string
  default = "false"
}

variable "ingress_host_name" {
  description = "Ingress host name for Jenkins"
  type = string
  default = ""
}

variable "template_vars" {
  description = "Variables to be passed to the values.tpl template"
  type = map(any)
  default = {}
}