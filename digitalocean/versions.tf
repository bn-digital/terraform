terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.20"
    }
  }
  required_version = ">= 1.0.0"
}