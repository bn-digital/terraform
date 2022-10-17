variable "project" {
  type        = string
  description = "Project name. Used as Cluster/VPC/Space name prefixes as well"
}

variable "environment" {
  type    = string
  description = "Application environment (one of: production | staging)"
  default = "production"
}

variable "region" {
  type    = string
  description = "DigitalOcean region slug"
  default = "nyc3"
}

variable "tags" {
  type    = list(string)
  description = "Resource tags"
  default = []
}

variable "cluster_node_size" {
  type    = string
  description = "DigitalOcean droplet slug"
  default = "s-2vcpu-4gb-intel"
}

variable "cluster_node_count" {
  type    = number
  description = "Initial cluster size (number of non-master nodes)"
  default = 1
}

variable "cluster_version" {
  type    = string
  description = "DigitalOcean patched kubernetes version"
  default = "1.24.4-do.0"
}