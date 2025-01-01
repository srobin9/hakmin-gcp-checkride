resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = var.namespace
  }
}

# Wordpress Helm release
# ref: https://github.com/bitnami/charts/tree/main/bitnami/wordpress/
resource "helm_release" "wordpress" {
  depends_on = [kubernetes_namespace.wordpress]
  timeout    = 600 #10분

  name       = var.release_name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace
 # version    = var.chart_version

  set_sensitive {
    name = "wordpressUsername"
    value = var.admin_user 
  }

  set_sensitive {
    name = "wordpressPassword"
    value = var.admin_password
  }

  set_sensitive {
    name = "mariadb.auth.rootPassword"
    value = var.db_password
  }
}