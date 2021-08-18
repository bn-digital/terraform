output "kubernetes_config" {
  sensitive  = true
  depends_on = [digitalocean_kubernetes_cluster.this]
  value      = digitalocean_kubernetes_cluster.this.kube_config[0]
}