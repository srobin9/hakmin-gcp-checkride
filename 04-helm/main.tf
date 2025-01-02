locals {
  env             = terraform.workspace
  gke_clusters    = data.terraform_remote_state.gke_clusters.outputs

  #GKE Cluster가 여러개일 때는 arg를 1, 2...로 늘려서, 각 클러스터별로 Helm 적용 (단, 프로젝튼 복사 등을 하여야 함)
  helm_providers  = {
    name       = local.gke_clusters.gke_cluster_names[0]
    endpoint   = local.gke_clusters.gke_cluster_endpoints[0]
    ca_cert    = local.gke_clusters.gke_cluster_ca_certificates[0]
    project_id = local.gke_clusters.gke_cluster_project_ids[0]
    location   = local.gke_clusters.gke_cluster_locations[0]
  }
}

output "helm_providers" {
  value = local.helm_providers
}

module "helm-jenkins" {
  source            = "./modules/41-helm-jenkins"

  release_name      = "${local.env}-jenkins"
  namespace         = "${local.env}-jenkins-namespace"
  chart_version     = var.helm_jenkins.chart_version
  ingress_enabled   = var.helm_jenkins.ingress_enabled
  ingress_host_name = var.helm_jenkins.ingress_host_name
  admin_user        = var.helm_jenkins.admin_user
  admin_password    = var.helm_jenkins.admin_password
}

module "helm-argocd" {
  source            = "./modules/42-helm-argocd"

  release_name        = "${local.env}-argocd"
  namespace           = "${local.env}-argocd-namespace"
  chart_version       = var.helm_argocd.chart_version
  argocd_server_host  = "${local.env}-argocd-server-host"
}

# 아래 에러가 지속 발생하여 데모시에 보여주지 않고, GKE Cluster에 직접 띄움
# Pod ephemeral local storage usage exceeds the total limit of containers 50Mi.	
/**
module "helm-wordpress" {
  source            = "./modules/43-helm-wordpress"

  release_name      = "${local.env}-wordpress"
  namespace         = "${local.env}-wordpress-namespace"
  admin_user        = var.helm_wordpress.admin_user
  admin_password    = var.helm_wordpress.admin_password
  db_password       = var.helm_wordpress.db_password
}
**/