resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = var.release_name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    templatefile(
      "${path.module}/templates/values.yaml.tpl",
      {
        "argocd_server_host"          = var.argocd_server_host
/**
        "argocd_github_client_id"     = var.argocd_github_client_id
        "argocd_github_client_secret" = var.argocd_github_client_secret
        "argocd_github_org_name"      = var.argocd_github_org_name
**/
        "argocd_ingress_enabled"                 = var.argocd_ingress_enabled
        "argocd_ingress_tls_acme_enabled"        = var.argocd_ingress_tls_acme_enabled
        "argocd_ingress_ssl_passthrough_enabled" = var.argocd_ingress_ssl_passthrough_enabled
        "argocd_ingress_class"                   = var.argocd_ingress_class
        "argocd_ingress_tls_secret_name"         = var.argocd_ingress_tls_secret_name
      }
    )
  ]
}