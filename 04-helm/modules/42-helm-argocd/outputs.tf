output "release_name" {
    description = "ArgoCD Helm release name"
    value       = helm_release.argocd.name
}

output "namespace" {
    description = "Kubernetes namespace for ArgoCD"
    value       = kubernetes_namespace.argocd.metadata.0.name
}

output "argocd_metadata" {
    description = "metadata object output of helm"
    value       = helm_release.argocd.metadata
}
