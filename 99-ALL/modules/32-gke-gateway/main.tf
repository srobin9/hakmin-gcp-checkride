# Provider 설정을 variables.tf에 정의한 변수들로 이동
provider "kubernetes" {
  host  = var.k8s_host
  token = var.k8s_token
  cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
}

resource "kubernetes_namespace" "gateway_namespace" {
  metadata {
    name = var.gateway_namespace
  }
}

# GatewayClass Type referece: https://cloud.google.com/kubernetes-engine/docs/concepts/gateway-api?hl=ko
# GatewayClass 리소스 정의
resource "kubernetes_manifest" "gateway" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = var.gateway_name
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
            "namespaces"    = {
                "from"      = "All"
/**
                "from"      = "Selector",
                "selector"  = {
                    "matchLabels" = {
                        "kubernetes.io/metadata.name" = "default"
                    }
                }
**/
            }
          }
        },
/**
        {
          "name" = "https"
          "port" = 443
          "protocol" = "HTTPS"
          "allowedRoutes" = {
            "kinds" = [
              {
                "kind" = "HTTPRoute"
              }
            ]
          }
          "tls" = {
             "mode" = "Terminate"
             "certificateRefs" = [
               {
                  "kind" = "Secret"
                  "name" = var.tls_secret_name
               }
             ]
          }
        }
**/
      ]
    }
  }
  depends_on = [
    kubernetes_namespace.gateway_namespace
  ]
}

# HTTPRoute 리소스 정의
resource "kubernetes_manifest" "http_route" {
  provider = kubernetes

  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1beta1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name"      = "http-route"
      "namespace" = "default" # 애플리케이션 네임스페이스
    }
    "spec" = {
      "parentRefs" = [
        {
          "kind"      = "Gateway"
          "name"      = kubernetes_manifest.gateway.manifest.metadata.name
          "namespace" = kubernetes_manifest.gateway.manifest.metadata.namespace
        },
      ]
/**
      "hostnames" = [
        "www.example.com", # 실제 호스트 이름으로 변경
      ]
**/
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
              "name" = "nginx-service" # 애플리케이션 서비스 이름
              "port" = 80
            }
          ]
        },
        {
          "matches" = [
            {
              "path" = {
                "type"  = "PathPrefix",
                "value" = "/httpd"
              }
            }
          ]
          "backendRefs" = [
            {
              "kind" = "Service",
              "name" = "httpd-service", # 애플리케이션 서비스 이름
              "port" = 80
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_manifest.gateway
  ]
}