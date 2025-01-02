locals {
  env = terraform.workspace
}

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