variable "release_name" {
  description = "Wordpress Helm release name"
  type        = string
  default     = ""
}

variable "repository" {
  description = "Wordpress Helm chart repository"
  type        = string
  default     = "oci://registry-1.docker.io/bitnamicharts"
}

variable "namespace" {
  description = "Namespace to release wordpress into"
  type        = string
  default     = "wordpress"
}

variable "chart" {
  description = "Wordpress Helm chart name"
  type        = string
  default     = "wordpress"
}

/**
variable "chart_version" {
  description = "wordpress helm chart version to use"
  type        = string
  default     = "2.4.9"
}
**/

variable "admin_user" {
  description = "Admin name for Jenkins"
  type = string
  default = ""
}

variable "admin_password" {
  description = "Admin password for Jenkins"
  type = string
  default = ""
}

variable "db_password" {
  description = "DB password for Jenkins"
  type = string
  default = ""
}