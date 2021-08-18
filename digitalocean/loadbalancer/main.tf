data "digitalocean_kubernetes_cluster" "this" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.this.endpoint
    token                  = data.digitalocean_kubernetes_cluster.this.kube_config[0].token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  }
}

locals {
  ingress_service_annotation_group = "service\\.beta\\.kubernetes\\.io"
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "kube-system"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  wait             = true
  cleanup_on_fail  = true
  create_namespace = true
  max_history      = 3
  set {
    name  = "defaultBackend.enabled"
    value = "false"
  }
  set {
    name  = "controller.priorityClassName"
    value = "system-cluster-critical"
  }
  set {
    name  = "service.omitClusterIP"
    value = "true"
  }
  set {
    name  = "service.annotations.${local.ingress_service_annotation_group}/do-loadbalancer-name"
    value = var.domain_name
  }
  set {
    name  = "service.annotations.${local.ingress_service_annotation_group}/do-loadbalancer-tag"
    value = var.domain_name
  }
  set {
    name  = "service.annotations.${local.ingress_service_annotation_group}/do-loadbalancer-protocol"
    value = "https"
  }
  set {
    name  = "service.annotations.${local.ingress_service_annotation_group}/do-loadbalancer-redirect-http-to-https"
    value = "true"
  }
}
