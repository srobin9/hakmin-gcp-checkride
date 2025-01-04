# Required if using User ADCs (Application Default Credentials) for Org Policy API.
provider "google" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = local.k8s_providers.location # 리전 변수 추가
  default_labels = {
    goog-cloudsetup = "downloaded"
  }
}

# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# Configure the Google Cloud Beta provider
provider "google-beta" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = local.k8s_providers.location # 리전 변수 추가
}

# GKE 인증 설정
data "google_client_config" "default" {
}

# Kubernetes 제공자 구성
provider "kubernetes" {
  host                   = "https://${local.k8s_providers.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.k8s_providers.ca_cert)
}