# Required if using User ADCs (Application Default Credentials) for Org Policy API.
provider "google" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = local.helm_providers.location # 리전 변수 추가
  default_labels = {
    goog-cloudsetup = "downloaded"
  }
}

# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# Configure the Google Cloud Beta provider
provider "google-beta" {
  user_project_override = var.user_project_override
  billing_project       = var.billing_project
  region                = local.helm_providers.location # 리전 변수 추가
}

# Helm Provider 설정
data "google_client_config" "default" {
}

# Kubernetes 제공자 구성
provider "kubernetes" {
  host                   = "https://${local.helm_providers.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(local.helm_providers.ca_cert)
}

# Helm 제공자 구성
provider "helm" {
  kubernetes {
    host                   = "https://${local.helm_providers.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(local.helm_providers.ca_cert)
  }
}

/**
provider "helm" {
  kubernetes {
    config_path     = "~/.kube/config"
    config_context  = "gke_${local.helm_providers.project_id}_${local.helm_providers.location}_${local.helm_providers.name}"
  }
}
**/