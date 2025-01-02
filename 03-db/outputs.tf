# outputs.tf (루트 모듈)

output "gke_cluster_names" {
  description = "GKE cluster names"
  value       = { for k, v in module.gke_cluster : k => v.cluster_name }
}

output "gke_cluster_endpoints" {
  description = "GKE cluster endpoints"
  value       = { for k, v in module.gke_cluster : k => v.cluster_endpoint }
}

output "gke_cluster_locations" {
  description = "GKE cluster locations"
  value       = { for k, v in module.gke_cluster : k => v.cluster_location }
}

output "gke_cluster_ca_certificates" {
  description = "GKE cluster CA certificates"
  value       = { for k, v in module.gke_cluster : k => v.cluster_ca_certificate }
  sensitive   = true
}

output "gke_cluster_project_ids" {
  description = "GKE cluster project IDs"
  value       = { for k, v in module.gke_cluster : k => v.cluster_project_id }
}