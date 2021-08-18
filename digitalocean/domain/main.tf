provider "digitalocean" {}

resource "digitalocean_domain" "this" {
  name = var.domain_name
}

resource "digitalocean_record" "this" {
  domain = var.domain_name
  name =   "@"
  type =   "A"
  value = var.loadbalancer_public_ip
  ttl =    1800
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "digitalocean_record" "www" {
  domain = digitalocean_record.this.name
  name =   "www"
  type =   "CNAME"
  value =  var.domain_name
  ttl =    3600
}

resource "digitalocean_certificate" "this" {
  name = var.domain_name
  domains = [digitalocean_record.this.fqdn, digitalocean_record.www.fqdn]
}


resource "digitalocean_certificate" "this" {
  name =    var.domain_name
  domains = [digitalocean_domain.this.name]
}

resource "digitalocean_record" "this" {
  for_each = var.domain_records

  domain =   digitalocean_domain.this.name
  name =     each.value.name
  type =     each.value.type
  value =    each.value.value
  priority = 0

  lifecycle {
    ignore_changes = [ttl, priority]
  }
}
