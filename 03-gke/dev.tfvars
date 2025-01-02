org_id          = "497314095400"
billing_account = "01ADFE-044C15-B43759"
billing_project = "cs-host-b0532598bd5c475e8d3843"

project_name    = "development-service"
region          = "asia-northeast3"

gke_clusters = [
  {
    gke_deletion_protection = false #On version 5.0.0+ of the provider, you must explicitly set deletion_protection = false and run terraform apply to write the field to state in order to destroy a cluster.
    subnet_name             = "subnet-gke"
    enable_autopilot        = true
    gateway_channel         = "CHANNEL_STANDARD"
    #  master_authorized_range = "10.100.0.0/24"  
  }
]

private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.10.0/28"
    master_global_access    = true
}