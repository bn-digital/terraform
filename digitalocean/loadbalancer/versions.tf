terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 1.0.0"
}
