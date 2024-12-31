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

variable "prefix" {
  description = "The prefix to create project_id" 
  type        = string
  default     = "01ADFE-044C15-B43759"
}

variable "folders" {
  description = "Folder structure as a map"
  type        = map
}

variable "groups" {
  description = "Group structure as a map"
  type = map(object({
    id          = string
    display_name = string
    types        = list(string)
  }))
}

variable "shared_vpcs" {
  type = map(object({
    network_name = string
    subnets      = list(object({
      subnet_name               = string
      subnet_ip                 = string
      subnet_region             = string
      subnet_private_access     = bool
      subnet_flow_logs          = bool
      subnet_flow_logs_sampling = string
      subnet_flow_logs_metadata = string
      subnet_flow_logs_interval = string
    }))
  }))
}

variable "shared_firewall_rules" {
  type = list(object({
    name      = string
    direction = string
    priority  = number
    allow     = list(object({
      protocol = string
      ports    = list(string)
    }))
    ranges = list(string)
  }))
}

variable "service_projects" {
  description = "Workload projects except common project"
  type = map(object({
    name            = string
    folder_name     = string
    shared_vpc_key  = string
    group_key       = string
  }))
}

variable "net_vpcs" {
  description = "VPC network configurations"
  type = map(object({
    project_name = string
    network_name = string
    subnets      = list(object({
      subnet_ip           = string
      subnet_name         = string
      subnet_region       = string
      secondary_ip_ranges = optional(map(string))
      flow_logs_config    = optional(object({
        flow_sampling         = number
        aggregation_interval  = string
      }))
    }))
  }))
}

variable "nat_region" {
  description = "The region for cloud NAT" 
  type        = string
  default     = "asia-northeast3"
}

variable "gke_clusters" {
  description = "gke cluster configurations"
  type = map(object({
    gke_deletion_protection = bool #On version 5.0.0+ of the provider, you must explicitly set deletion_protection = false and run terraform apply to write the field to state in order to destroy a cluster.
    project_name            = string
    region                  = string
    network_name            = string
    subnet_name             = string
    enable_autopilot        = bool
  #  master_authorized_range = string


  
  }))
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

variable "private_service_ranges" {
  description = "Private service IP CIDR ranges."
  type        = map(string)
  default = {
    cluster = "192.168.10.0/28"
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

variable "helm_jenkins" {
  description = "Helm Jenkins configurations"
  type = map(object({
    chart_version     = string
    ingress_enabled   = bool
    ingress_host_name = string
    admin_user        = string
    admin_password    = string
  }))
}

variable "helm_argocd" {
  description = "Helm ArgoCD configurations"
  type = map(object({
    chart_version       = string
  }))
}