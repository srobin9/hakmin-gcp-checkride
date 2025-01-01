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
  type = string
  default = "asia-northeast3" # 기본 리전 설정
}

variable "gke_clusters" {
  description = "gke cluster configurations"
  type = list(object({
    gke_deletion_protection = bool #On version 5.0.0+ of the provider, you must explicitly set deletion_protection = false and run terraform apply to write the field to state in order to destroy a cluster.
    network_name            = string
    subnet_name             = string
    enable_autopilot        = bool
    gateway_channel         = string
  #  master_authorized_range = string 
  }))
}

variable "create_gke_cluster" {
  description = "Whether to create a GKE cluster"
  type        = bool
  default     = true
}

variable "node_machine_type" {
  description = "GKE node pool machine type."
  type        = string
  default     = "n1-standard-1"
}

variable "initial_node_count" {
  description = "Number of initial nodes in node pool."
  type        = number
  default     = 1
}

variable "private_cluster_config" {
  description = "Priviate cluster configuration including private service IP CIDR ranges."
  type        = map(string)
  default = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.10.0/28"
    master_global_access    = true
  }
}

variable "node_shielded_instance_config" {
  description = "Shielded instance options."
  type = object({
    enable_secure_boot          = bool
    enable_integrity_monitoring = bool
    enable_vtpm                 = bool
  })
  default = {
    enable_secure_boot          = true
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }
}

variable "gke_addons" {
  description = "GKE add-ons to configure for cluster."
  type = object({
    cloudrun_config            = bool
    dns_cache_config           = bool
    horizontal_pod_autoscaling = bool
    http_load_balancing        = bool
    istio_config = object({
      enabled = bool
      tls     = bool
    })
    network_policy_config                 = bool
    gce_persistent_disk_csi_driver_config = bool
  })
  default = {
    cloudrun_config            = false
    dns_cache_config           = false
    horizontal_pod_autoscaling = true
    http_load_balancing        = true
    istio_config = {
      enabled = false
      tls     = false
    }
    network_policy_config                 = false
    gce_persistent_disk_csi_driver_config = false
  }
}