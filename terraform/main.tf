terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "demo" {
    metadata {
        name = "demo"
    }
}

resource "kubernetes_deployment" "tfc_operator_demo_app" {
  metadata {
    name = "tfc-operator-demo-app"
    namespace = kubernetes_namespace.demo.metadata[0].name

    labels = {
      app = "tfc_operator_demo"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "tfc-operator-demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "tfc-operator-demo"
        }
      }

      spec {
        container {
          image = "redeux/tfc-operator-demo-app:latest"
          name  = "demo-app"

          resources {
            limits = {
              cpu    = "200m"
              memory = "100Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

data "kubernetes_service" "tfc_operator_demo_app" {
  metadata {
    name = "tfc-operator-demo-app"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

}