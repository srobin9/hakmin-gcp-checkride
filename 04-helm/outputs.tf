output "jenkins_name" {
  description   = "Names of Jenkins"
  value         = module.helm-jenkins.release_name
}

output "jenkins_namespace" {
  description   = "Namespace of the Jenkins"
  value         = module.helm-jenkins.namespace
}

output "jenkins_metadata" {
  description   = "Metadata of the Jenkins"
  value         = module.helm-jenkins.jenkins_meatadata
}

output "argocd_name" {
  description   = "Names of ArgoCD"
  value         = module.helm-argocd.release_name
}

output "argocd_namespace" {
  description   = "Namespace of the ArgoCD"
  value         = module.helm-argocd.namespace
}

output "argocd_metadata" {
  description   = "Metadata of the ArgoCD"
  value         = module.helm-argocd.argocd_metadata
}

/**
output "wordpress_name" {
  description   = "Names of Wordpress"
  value         = module.helm-wordpress.release_name
}

output "wordpress_namespace" {
  description   = "Namespace of the Wordpress"
  value         = module.helm-wordpress.namespace
}

output "wordpress_metadata" {
  description   = "Metadata of the Wordpress"
  value         = module.helm-wordpress.wordpress_metadata
}
**/