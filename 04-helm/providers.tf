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
data "google_client_config" "default" {}

# Kubernetes 제공자 구성
provider "kubernetes" {
    host                   = "https://${module.gke_cluster["dev"].cluster_endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke_cluster["dev"].cluster_ca_certificate)
}

# Helm 제공자 구성
provider "helm" {
    kubernetes {
      host                   = "https://${module.gke_cluster["dev"].cluster_endpoint}"
      token                  = data.google_client_config.default.access_token
      cluster_ca_certificate = base64decode(module.gke_cluster["dev"].cluster_ca_certificate)
    }
}