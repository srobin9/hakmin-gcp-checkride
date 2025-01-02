# modules/jenkins-helm/outputs.tf

output "release_name" {
  description = "Jenkins Helm release name"
  value       = helm_release.jenkins.name
}

output "namespace" {
  description = "Kubernetes namespace for Jenkins"
  value       = kubernetes_namespace.jenkins.metadata.0.name
}

# modules/jenkins-helm/outputs.tf
 output "jenkins_meatadata" {
     description = "metadata object output of helm"
     value = helm_release.jenkins.metadata
 }
