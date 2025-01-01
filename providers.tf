# Required if using User ADCs (Application Default Credentials) for Org Policy API.
provider "google" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = var.region # 리전 변수 추가
  default_labels = {
    goog-cloudsetup = "downloaded"
  }
}

# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# Configure the Google Cloud Beta provider
provider "google-beta" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = var.region # 리전 변수 추가
}

# Helm Provider 설정
provider "helm" {
  kubernetes {
    # config_path = "~/.kube/config" # 로컬 kubeconfig 파일 사용 시
    # 또는 host, client_certificate, client_key, cluster_ca_certificate 등을 사용하여 직접 설정 가능

    # 예시: Google Kubernetes Engine (GKE) 클러스터에 연결
    host                   = data.google_container_cluster.my_cluster.endpoint
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth.0.cluster_ca_certificate)
  }
}