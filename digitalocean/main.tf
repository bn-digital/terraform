locals {
  infrastructure = {
    project     = lower(var.project)
    environment = lower(var.environment)
    provisioner = lower("Terraform")
  }
  tags = formatlist("%s:%s", keys(local.infrastructure), values(local.infrastructure))
}

resource "digitalocean_tag" "this" {
  count = length(local.tags)
  name  = local.tags[count.index]
}

module "cluster" {
  source = "./cluster"

  project         = local.infrastructure.project
  environment     = local.infrastructure.environment
  region          = var.region == "us" ? "nyc3" : (var.region == "eu" ? "fra1" : var.region)
  cluster_version = var.kubernetes_version
  tags            = local.tags
}

module "domain" {
  count = var.domain != "" ? 1 : 0

  source = "./domain"

  domain  = var.domain
  records = var.google_managed_mail ? merge(local.google-workspace-mail, var.domain_records) : var.domain_records
}

resource "digitalocean_project" "this" {
  name        = local.infrastructure.project
  environment = local.infrastructure.environment
  purpose     = "Web Application"
  description = "${local.infrastructure.project} web app ${local.infrastructure.environment} environment"
}
