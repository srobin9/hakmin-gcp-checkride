org_id          = "497314095400"
billing_project = "cs-host-b0532598bd5c475e8d3843"

helm_jenkins = {
  chart_version     = "5.7.26"
  ingress_enabled   = true
  ingress_host_name = "jenkins.example.com"
  admin_user        = "admin"
  admin_password    = "admin1234"
}

helm_argocd = {
  chart_version     = "7.7.11"
}

helm_wordpress = {
  admin_user        = "admin"
  admin_password    = "admin1234"
  db_password       = "dbms1234"
}