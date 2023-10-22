terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/free-k8s-config"
}

provider "oci" {
  region = var.region
  private_key = var.private_key
}

resource "kubernetes_namespace" "free_namespace" {
  metadata {
    name = "free-ns"
  }
}

data "http" "cert_manager_script" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml"
}

resource "kubectl_manifest" "cert_manager" {
  yaml_body = data.http.cert_manager_script.response_body
}

resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = templatefile("${path.module}/yamls/cluster-issuer.tftpl", { certificate_email = var.certificate_email })
}

data "http" "nginx_ingress_script" {
  url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/release-1.9/deploy/static/provider/oracle/deploy.yaml"
}

resource "kubectl_manifest" "ingress_controller" {
  yaml_body = data.http.nginx_ingress_script.response_body
}
