locals {
  google-workspace-mail = {
    default = {
      name     = "@",
      value    = "aspmx.l.google.com.",
      type     = "MX"
      priority = 0
    }
    alternative-1 = {
      name     = "@",
      value    = "alt1.aspmx.l.google.com.",
      type     = "MX"
      priority = 5

    }
    alternative-2 = {
      name     = "@",
      value    = "alt2.aspmx.l.google.com.",
      type     = "MX"
      priority = 5
    }
    alternative-3 = {
      name     = "@",
      value    = "alt3.aspmx.l.google.com.",
      type     = "MX"
      priority = 10
    }
    alternative-4 = {
      name     = "@",
      value    = "alt4.aspmx.l.google.com.",
      type     = "MX"
      priority = 10
    }
  }
}

variable "project" {
  type        = string
  description = "Project name. Used as Cluster/VPC/Space name prefixes as well"
}

variable "environment" {
  type        = string
  description = "Application environment (one of: production | staging)"
  default     = "production"
}

variable "domain" {
  type        = string
  description = "Primary application domain name"
}

variable "domain_records" {
  type        = map(object({
    name     = string,
    value    = string,
    type     = string,
    priority = number
  }))
  description = "Domain records"
  default = {}
}

variable "region" {
  type        = string
  description = "Regional zone where resources will be created (one of: us | eu). Proper region will be selected automatically."
  default     = "us"
}

variable "google_managed_mail" {
  type        = string
  description = "If mail is managed by Google, flag used to create default MX records"
  default     = false
}

variable "kubernetes_version" {
  type        = string
  description = "DigitalOcean patched kubernetes version (one of: latest | 1.xx.x-do.x)"
  default     = "1.22.8-do.1"
}