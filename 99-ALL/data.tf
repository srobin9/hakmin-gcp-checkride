data "google_organization" "org" {
  organization = "organizations/${var.org_id}"
}

data "terraform_remote_state" "gke_cluster" {
  backend = "gcs"
  config = {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/01-landingzone/"
  }
}