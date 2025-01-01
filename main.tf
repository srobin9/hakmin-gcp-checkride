module "landing_zone" {
  source                = "./modules/10-landing-zone"
  folders               = var.folders
  org_id                = var.org_id
  billing_account       = var.billing_account
  prefix                = var.prefix
  directory_customer_id = data.google_organization.org.directory_customer_id
  org_domain            = data.google_organization.org.domain
  groups                = var.groups
  shared_vpcs           = var.shared_vpcs
  shared_firewall_rules = var.shared_firewall_rules # 변수 사용 또는 삭제
  service_projects      = var.service_projects
}

module "service_project_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 16.0"

  for_each = var.service_projects

  project_id = module.landing_zone.project_ids_by_name[each.value.name]

  activate_apis = [
    "container.googleapis.com", # Kubernetes Engine API
  ]

  disable_dependent_services = true
  disable_services_on_destroy = false

  depends_on = [module.landing_zone]

}

module "service_vpcs" {
  source     = "./modules/20-net-vpc"
  for_each   = var.net_vpcs

  project_id = module.landing_zone.project_ids_by_name[each.value.project_name]
  name       = each.value.network_name

  subnets = [
    for subnet in each.value.subnets : {
      name                  = subnet.subnet_name
      ip_cidr_range         = subnet.subnet_ip
      region                = subnet.subnet_region
      secondary_ip_ranges   = subnet.secondary_ip_ranges
      flow_logs_config      = subnet.flow_logs_config
    }
  ]

  depends_on = [module.service_project_apis]
}

module "service_firewall" {
  source     = "./modules/21-net-vpc-firewall"
  for_each   = var.net_vpcs

  project_id = module.landing_zone.project_ids_by_name[each.value.project_name]
  network    = each.value.network_name

  depends_on = [module.service_vpcs]
}

module "service_nat" {
  source     = "./modules/22-net-cloudnat"
  for_each   = var.net_vpcs

  project_id = module.landing_zone.project_ids_by_name[each.value.project_name]

  region         = var.nat_region
  name           = "${each.value.network_name}-nat"
  router_create  = true
  router_network = each.value.network_name

  depends_on = [module.service_vpcs]
}

module "gke_cluster" {
  source                  = "./modules/30-gke-cluster"
  for_each                = var.gke_clusters
  deletion_protection     = each.value.gke_deletion_protection
  name                    = "${each.key}-${each.value.region}-gke-cluster"
  project_id              = module.landing_zone.project_ids_by_name[each.value.project_name]
  location                = each.value.region
  network                 = each.value.network_name
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

  depends_on = [module.service_vpcs, module.service_project_apis]
}

module "gke_cluster_nodepool" {
  source                     = "./modules/31-gke-nodepool"
  for_each = {
    for k, v in var.gke_clusters : k => v if v.enable_autopilot == false # 조건식 추가
  }

  name                       = "${each.key}-nodepool"
  project_id                 = module.landing_zone.project_ids_by_name[each.value.project_name]
  location                   = each.value.region
  cluster_name               = "${each.key}-${each.value.region}-gke-cluster"
  node_service_account_create = true
#  node_service_account_name   = "${each.key}-nodepool-sa" # 서비스 계정 이름 일관되게 변경
  initial_node_count         = var.initial_node_count
  node_machine_type          = var.node_machine_type
  node_shielded_instance_config = var.node_shielded_instance_config

  depends_on = [module.gke_cluster]
}

/**
module "gke_gateway" {
  source = "./modules/32-gke-gateway" # 모듈 경로
  gateway_name      = var.gke_gateway.gateway_name
  gateway_namespace = var.gke_gateway.gateway_namespace
  #tls_secret_name           = var.gke_gateway.tls_secret_name

# 변수 추가 및 값 할당
  k8s_host                   = "https://${module.gke_cluster["dev"].cluster_endpoint}"
  k8s_token                  = data.google_client_config.default.access_token
  k8s_ca_certificate         = module.gke_cluster["dev"].cluster_ca_certificate

#  depends_on = [module.gke_cluster]
}
**/

module "vm_bastion" {
  source       = "./modules/39-compute-vm"
  for_each = {
    for k, v in var.gke_clusters : k => v if var.private_cluster_config.enable_private_endpoint == true # 조건식 추가
  }

  project_id   = module.landing_zone.project_ids_by_name[each.value.project_name]
  region       = each.value.region
  name         = "${each.key}-bastion"
  network_interfaces = [{
    network    = module.service_vpcs[each.key].self_link
    subnetwork = try(module.service_vpcs[each.value.network_name].subnet_self_links["${each.value.region}/subnet-${each.key}-general"], null)
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
  depends_on             = [module.service_vpcs]
}

/**
module "helm-jenkins" {
  source            = "./modules/41-helm-jenkins"

  for_each          = var.helm_jenkins
  release_name      = "${each.key}-jenkins"
  namespace         = "${each.key}-jenkins-namespace"
  chart_version     = each.value.chart_version
  ingress_enabled   = each.value.ingress_enabled
  ingress_host_name = each.value.ingress_host_name
  admin_user        = each.value.admin_user
  admin_password    = each.value.admin_password

  depends_on = [module.gke_cluster]
}

module "helm-argocd" {
  source            = "./modules/42-helm-argocd"

  for_each            = var.helm_argocd
  release_name        = "${each.key}-argocd"
  namespace           = "${each.key}-argocd-namespace"
  chart_version       = each.value.chart_version
  argocd_server_host  = "${each.key}-argocd-server-host"

  depends_on = [module.gke_cluster]
}

module "helm-wordpress" {
  source            = "./modules/43-helm-wordpress"

  for_each          = var.helm_wordpress
  release_name      = "${each.key}-wordpress"
  namespace         = "${each.key}-wordpress-namespace"
##  chart_version    = each.value.chart_version
  admin_user        = each.value.admin_user
  admin_password    = each.value.admin_password
  db_password       = each.value.db_password

  depends_on = [module.gke_cluster]
}
**/