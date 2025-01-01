data "google_organization" "org" {
  organization = "organizations/${var.org_id}"
}

data "terraform_remote_state" "landing_zone" {
  backend = "gcs" # Project A와 동일한 백엔드 타입
  config = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/01-landingzone/"  }
}