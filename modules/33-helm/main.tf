# GKE 클러스터 정보 가져오기 (GKE 사용 시)
data "google_container_cluster" "my_cluster" {
  name     = "your-gke-cluster-name"  # GKE 클러스터 이름
  location = "your-gke-cluster-location" # GKE 클러스터 리전 또는 존
  project  = "your-gcp-project-id"     # GCP 프로젝트 ID
}

data "google_client_config" "current" {}

# Helm 저장소 추가
resource "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

# 젠킨스 릴리스
resource "helm_release" "jenkins" {
  name       = "my-jenkins" # 릴리스 이름
  repository = helm_repository.bitnami.name
  chart      = "jenkins"
  namespace  = "jenkins" # 네임스페이스
  create_namespace = true  # 네임스페이스 자동 생성

  # values.yaml 파일 설정
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name = "persistence.enabled"
    value = "true"
  }

  set {
    name = "persistence.storageClass"
    value = "standard" # 스토리지 클래스 (환경에 맞게 변경)
  }

  set {
    name = "persistence.size"
    value = "50Gi"
  }

  # values.yaml 파일 경로 지정 (선택 사항)
  # values = [
  #   "${file("values.yaml")}"
  # ]
}