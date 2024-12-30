variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "your-gke-cluster-name" # 기본값 설정
}

variable "gke_cluster_location" {
  description = "The location (region or zone) of the GKE cluster"
  type        = string
  default     = "your-gke-cluster-location" # 기본값 설정
}

variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "your-gcp-project-id" # 기본값 설정
}