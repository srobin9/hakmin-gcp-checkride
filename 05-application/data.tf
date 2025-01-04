data "google_organization" "org" {
  organization = "organizations/${var.org_id}"
}

data "terraform_remote_state" "landing_zone" {
  backend = "gcs" # Project A와 동일한 백엔드 타입
  config = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/01-landingzone/"  }
}

data "terraform_remote_state" "gke_clusters" {
  backend   = "gcs" 
  workspace = "${local.env}" #workspace 사용 시 반드시 추가해야 되는 옵션
  config    = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/03-gke/"  
  }
}