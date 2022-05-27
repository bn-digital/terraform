output "resources" {
  value = [digitalocean_domain.this.urn]
  sensitive = false
}