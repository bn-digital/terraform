
resource "digitalocean_vpc" "this" {
  region      = var.region
  name        = "${var.project}-newtwork"
  description = "Project resources network"
}

resource "digitalocean_spaces_bucket" "this" {
  name   = "${var.project}-cms"
  region = var.region
  acl    = "public-read"

  versioning {
    enabled = false
  }
}

resource "digitalocean_kubernetes_cluster" "this" {
  name          = var.project
  region        = var.region
  tags          = var.tags
  version       = var.cluster_version
  vpc_uuid      = digitalocean_vpc.this.id
  surge_upgrade = true

  node_pool {
    name       = "workers"
    tags       = var.tags
    size       = var.cluster_node_size
    auto_scale = true
    min_nodes  = var.cluster_node_count
    max_nodes  = var.cluster_node_count + 1
  }

  lifecycle {
    ignore_changes = [region]
  }

}
