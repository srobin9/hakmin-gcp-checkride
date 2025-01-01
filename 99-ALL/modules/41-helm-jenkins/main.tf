# modules/jenkins-helm/main.tf
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "jenkins" {
  name       = var.release_name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    "${file("./modules/41-helm-jenkins/jenkins_values.yaml")}"
  ]

  set_sensitive {
    name = "controller.admin.username"
    value = var.admin_user
  }

  set_sensitive {
    name = "controller.admin.password"
    value = var.admin_password
  }

  # values.yaml 파일에서 설정할 수 없는 값들을 설정
  set {
    name  = "controller.serviceType"
    value = var.service_type
  }

  set {
    name = "controller.ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name = "controller.ingress.hostName"
    value = var.ingress_host_name
  }

  depends_on = [kubernetes_namespace.jenkins]
}

# Jenkins 네임스페이스 생성 (선택 사항)
resource "kubernetes_namespace" "jenkins" {

  metadata {
    name = var.namespace
  }
}