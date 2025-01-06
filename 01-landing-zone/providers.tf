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
