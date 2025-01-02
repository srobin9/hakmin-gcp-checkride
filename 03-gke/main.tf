locals {
  env = terraform.workspace
}

module "gke_cluster" {
  source                  = "./modules/30-gke-cluster"
  for_each                = { for idx, cluster in var.gke_clusters : idx => cluster }
  deletion_protection     = each.value.gke_deletion_protection
  name                    = "${local.env}-gke-cluster-${each.key}"
  project_id              = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  location                = var.region
  network                 = data.terraform_remote_state.service_network.outputs.vpc_names
  subnetwork              = each.value.subnet_name
  enable_autopilot        = each.value.enable_autopilot
  gateway_channel         = each.value.gateway_channel
  secondary_range_pods    = "pods"
  secondary_range_services = "services"
  default_max_pods_per_node = 32
/**
  master_authorized_ranges = {
    internal-vms = each.value.master_authorized_range
  }
**/
  private_cluster_config = var.private_cluster_config

  addons                 = var.gke_addons
  enable_shielded_nodes  = true
}

module "gke_cluster_nodepool" {
  source    = "./modules/31-gke-nodepool"
  for_each  = {
    for idx, cluster in var.gke_clusters : idx => cluster 
    if cluster.enable_autopilot == false
  }

  name                          = "${local.env}-nodepool-${each.key}"
  project_id                    = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  location                      = var.region
  cluster_name                  = "${local.env}-gke-cluster-${each.key}"
  node_service_account_create   = true
#  node_service_account_name    = "${each.key}-nodepool-sa" # 서비스 계정 이름 일관되게 변경
  initial_node_count            = var.initial_node_count
  node_machine_type             = var.node_machine_type
  node_shielded_instance_config = var.node_shielded_instance_config

  depends_on = [module.gke_cluster]
}

module "vm_bastion" {
  source       = "./modules/32-compute-vm"
  for_each  = {
    for idx, cluster in var.gke_clusters : idx => cluster 
    if var.private_cluster_config.enable_private_endpoint == true
  }

  project_id   = data.terraform_remote_state.landing_zone.outputs.project_ids_by_name[var.project_name]
  region       = var.region
  name         = "${local.env}-bastion-${each.key}"
  network_interfaces = [{
    network    = data.terraform_remote_state.service_network.outputs.vpc_names
    subnetwork = "subnet-general"
    nat        = false
    addresses  = null
    alias_ips  = null
  }]
  instance_count = 1
  tags           = ["ssh"]
  metadata = {
    startup-script = join("\n", [
      "#! /bin/bash",
      "apt-get update",
      "apt-get install -y bash-completion kubectl dnsutils tinyproxy",
      "grep -qxF 'Allow localhost' /etc/tinyproxy/tinyproxy.conf || echo 'Allow localhost' >> /etc/tinyproxy/tinyproxy.conf",
      "service tinyproxy restart"
    ])
  }
  service_account_create = true
  shielded_config        = var.node_shielded_instance_config

  depends_on = [module.gke_cluster]
}