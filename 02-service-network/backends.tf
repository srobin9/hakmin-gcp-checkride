# service_network 프로젝트의 main.tf
terraform {
  backend "gcs" {
    bucket = "khm-tfstate-asia-northeast3-ca8e883247484090b411d314eeb5983e"
    prefix = "terraform/02-service-network/"
  }
}