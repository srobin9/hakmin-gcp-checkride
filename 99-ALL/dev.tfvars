org_id          = "497314095400"
billing_account = "01ADFE-044C15-B43759"
billing_project = "cs-host-b0532598bd5c475e8d3843"

gke_gateway = {
    gateway_name      = "http-external"
    gateway_namespace = "gke-gateway-namespace"
  #  tls_secret_name   = ""
}

helm_jenkins = {
  "dev" = {
    chart_version     = "5.7.26"
    ingress_enabled   = true
    ingress_host_name = "jenkins.example.com"
    admin_user        = "admin"
    admin_password    = "admin1234"
  }
}

helm_argocd = {
  "dev" = {
    chart_version     = "7.7.11"
  }
}

helm_wordpress = {
  "dev" = {
##    chart_version     = "7.7.11"
    admin_user        = "admin"
    admin_password    = "admin1234"
    db_password       = "dbms1234"
  }
}