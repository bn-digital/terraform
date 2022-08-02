resource "digitalocean_vpc" "this" {
  region      = var.region
  name        = "${var.project}-newtwork"
  description = "Project resources network"
}

resource "digitalocean_spaces_bucket" "this" {
  name   = "${var.project}-cms"
  region = var.region == "lon1" ? "ams3" : var.region
  acl    = "public-read"

  versioning {
    enabled = false
  }
}

resource "digitalocean_spaces_bucket_policy" "this" {
  bucket = digitalocean_spaces_bucket.this.name
  region = digitalocean_spaces_bucket.this.region
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "CmsUploadAcl",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::${digitalocean_spaces_bucket.this.name}",
          "arn:aws:s3:::${digitalocean_spaces_bucket.this.name}/*"
        ]
      }
    ]
  })
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
    node_count = var.cluster_node_count
  }

  lifecycle {
    ignore_changes = [region]
  }

}
