output "release_name" {
  description = "Wordpress Helm release name"
  value       = helm_release.wordpress.name
}

output "namespace" {
  description = "Kubernetes namespace for Wordpress"
  value       = kubernetes_namespace.wordpress.metadata.0.name
}

output "wordpress_metadata" {
  description = "metadata object output of helm"
  value       = helm_release.wordpress.metadata
}
