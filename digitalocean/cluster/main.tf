provider "digitalocean" {}

resource "digitalocean_tag" "project" {
  name = "project:${var.project}"
}

resource "digitalocean_tag" "provisioner" {
  name = "provisioner:terraform"
}

resource "digitalocean_tag" "controller" {
  name = "ingress:nginx"
}

resource "digitalocean_tag" "environment" {
  name = "environment:${var.environment}"
}

locals {
  tags = [digitalocean_tag.project.id, digitalocean_tag.environment.id, digitalocean_tag.provisioner.id]
}

resource "digitalocean_vpc" "this" {
  region      = var.cluster_region
  name        = "${var.project}-vpc"
  description = "Project ${var.environment} env resource network"
}

resource "digitalocean_spaces_bucket" "this" {
  name   = var.project
  region = var.spaces_region
  acl    = "public-read"
}

data "digitalocean_kubernetes_versions" "current" {
  version_prefix = var.cluster_version
}

resource "digitalocean_kubernetes_cluster" "this" {
  name     = var.project
  region   = var.cluster_region
  version  = data.digitalocean_kubernetes_versions.current.latest_version
  tags     = local.tags
  vpc_uuid = digitalocean_vpc.this.id

  lifecycle {
    ignore_changes = [region]
  }

  node_pool {
    name       = "default"
    tags       = concat(local.tags, [digitalocean_tag.controller.name])
    size       = var.cluster_node_size
    auto_scale = false
    node_count = var.cluster_node_count
    min_nodes  = var.cluster_node_count
    max_nodes  = var.cluster_node_count
  }
}

