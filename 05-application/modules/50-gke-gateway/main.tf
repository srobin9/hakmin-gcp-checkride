# Provider 설정을 variables.tf에 정의한 변수들로 이동

resource "kubernetes_namespace" "gateway_namespace" {
  metadata {
    name = var.gateway_namespace
  }
}

# Gateway 리소스 정의 (Tomcat)
resource "kubernetes_manifest" "tomcat_gateway" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "tomcat-gateway"
      "namespace" = var.gateway_namespace
    }
    "spec" = {
      "gatewayClassName" = "gke-l7-global-external-managed"
      "listeners" = [
        {
          "name" = "http"
          "port" = 80
          "protocol" = "HTTP"
          "allowedRoutes" = {
            "kinds" = [
              {
                "kind"      = "HTTPRoute"
              }
            ]
            "namespaces" = {
              "from" = "All"
            }
          }
        },
        # https listener 생략
      ]
    }
  }
  depends_on = [
    kubernetes_namespace.gateway_namespace
  ]
}

# Gateway 리소스 정의 (Nginx)
resource "kubernetes_manifest" "nginx_gateway" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "nginx-gateway"
      "namespace" = var.gateway_namespace
    }
    "spec" = {
      "gatewayClassName" = "gke-l7-global-external-managed"
      "listeners" = [
        {
          "name" = "http"
          "port" = 80
          "protocol" = "HTTP"
          "allowedRoutes" = {
            "kinds" = [
              {
                "kind"      = "HTTPRoute"
              }
            ]
            "namespaces" = {
              "from" = "All"
            }
          }
        },
        # https listener 생략
      ]
    }
  }
  depends_on = [
    kubernetes_namespace.gateway_namespace
  ]
}

# HTTPRoute 리소스 정의 (Tomcat)
resource "kubernetes_manifest" "tomcat_route" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "tomcat-route"
      "namespace" = var.app_namespace
    }
    "spec" = {
      "parentRefs" = [
        {
          "kind"      = "Gateway"
          "name"      = kubernetes_manifest.tomcat_gateway.manifest.metadata.name
          "namespace" = kubernetes_manifest.tomcat_gateway.manifest.metadata.namespace
        },
      ]
      "rules" = [
        {
          "matches" = [
            {
              "path" = {
                "type"  = "PathPrefix",
                "value" = "/"
              }
            }
          ]
          "backendRefs" = [
            {
              "kind" = "Service"
              "name" = "tomcat-service"
              "port" = 8080
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_manifest.tomcat_gateway
  ]
}

# HTTPRoute 리소스 정의 (Nginx)
resource "kubernetes_manifest" "nginx_route" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "nginx-route"
      "namespace" = var.app_namespace
    }
    "spec" = {
      "parentRefs" = [
        {
          "kind"      = "Gateway"
          "name"      = kubernetes_manifest.nginx_gateway.manifest.metadata.name
          "namespace" = kubernetes_manifest.nginx_gateway.manifest.metadata.namespace
        },
      ]
      "rules" = [
        {
          "matches" = [
            {
              "path" = {
                "type" = "PathPrefix"
                "value" = "/"
              }
            }
          ]
          "backendRefs" = [
            {
              "kind" = "Service"
              "name" = "nginx-service"
              "port" = 80
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_manifest.nginx_gateway
  ]
}

# Service 리소스 정의 수정
resource "kubernetes_service" "tomcat_service" {
  metadata {
    name      = "tomcat-service"
    namespace = var.app_namespace
  }
  spec {
    selector = {
      app = "tomcat"
    }
    port {
      port        = 8080
      target_port = 8080
      protocol = "TCP"
    }
      type = "ClusterIP" # ClusterIP로 변경
  }
}