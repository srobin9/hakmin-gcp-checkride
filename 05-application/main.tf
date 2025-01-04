locals {
  env             = terraform.workspace
  gke_clusters    = data.terraform_remote_state.gke_clusters.outputs

  #GKE Cluster가 여러개일 때는 arg를 1, 2...로 늘려서, 각 클러스터별로 Helm 적용 (단, 프로젝튼 복사 등을 하여야 함)
  k8s_providers  = {
    name       = local.gke_clusters.gke_cluster_names[0]
    endpoint   = local.gke_clusters.gke_cluster_endpoints[0]
    ca_cert    = local.gke_clusters.gke_cluster_ca_certificates[0]
    project_id = local.gke_clusters.gke_cluster_project_ids[0]
    location   = local.gke_clusters.gke_cluster_locations[0]
  }
}

module "gke_gateway" {
  source            = "./modules/50-gke-gateway" # 모듈 경로
  gateway_name      = var.gke_gateway.gateway_name
  gateway_namespace = var.gke_gateway.gateway_namespace
  app_namespace     = var.gke_gateway.app_namespace
  #tls_secret_name  = var.gke_gateway.tls_secret_name
}