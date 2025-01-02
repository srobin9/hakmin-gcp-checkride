data "google_organization" "org" {
  organization = "organizations/${var.org_id}"
}

data "terraform_remote_state" "landing_zone" {
  backend = "gcs"
  config  = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/01-landingzone/"  }
}

data "terraform_remote_state" "service_network" {
  backend   = "gcs" 
  workspace = "${local.env}" #workspace 사용 시 반드시 추가해야 되는 옵션
  config    = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/02-service-network/"  
  }
}