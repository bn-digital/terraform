output "resources" {
  value = [digitalocean_kubernetes_cluster.this.urn, digitalocean_spaces_bucket.this.urn, digitalocean_spaces_bucket.this.urn]
  sensitive = false
}