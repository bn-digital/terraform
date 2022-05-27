# Terraform Modules

## DigitalOcean

Provision DigitalOcean account, creating next resources:

- _Project_
- _Domain_
- _VPC_
- _Kubernetes Cluster_
- _Node Pool_ with autoscaling (1-2 _Droplets_ 2vCPU & 4Gb RAM)
- _Spaces Bucket_

### CI/CD Pipeline

#### Github Action

##### .github/workflows/continuous-delivery.yml

```yaml

name: Continuous Delivery
on:
  push:
    tags:
      - '*'

jobs:
  provision:
    uses: bn-digital/terraform/.github/workflows/provision-infrastructure.yml@latest
    secrets: inherit
    env:
      DIGITALOCEAN_TOKEN: ${{ secrets.DIGITALOCEAN_TOKEN }}
      SPACES_ACCESS_KEY_ID: ${{ secrets.SPACES_ACCESS_KEY_ID }}
      SPACES_SECRET_ACCESS_KEY: ${{ secrets.SPACES_SECRET_ACCESS_KEY }}
    with:
      domain: example.com # Could be stored as Github Secret - use then ${{ secrets.DOMAIN }}
      provider: digitalocean
      environment: production
```

### Example

#### Environment Variables

- `DIGITALOCEAN_TOKEN`
- `SPACES_ACCESS_KEY_ID`
- `SPACES_SECRET_ACCESS_KEY`

#### Infrastructure as a Code

##### variables.tf

```terraform

locals {
  app_name = basename(dirname("${path.cwd}/../../"))
  domain = var.domain == "" ? "${local.app_name}.bndigital.ai" : var.domain 
}

variable "domain" {
  type = string
  default = ""
}

variable "environment" {
  type = string
  default = "production"
}

```
##### terraform.tf

> Ensure key contains proper app-name!

```terraform
terraform {
  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com"
    key                         = "terraform/%app-name%/terraform.tfstate"
    bucket                      = "bn-digital"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

provider "digitalocean" { }
```

##### main.tf
```terraform

module "digitalocean" {
  source = "github.com/bn-digital/terraform//digitalocean"

  project =  local.project
  environment = var.environment
  domain = var.domain
}
```
