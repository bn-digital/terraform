variable "domain" {
  type        = string
  description = "Main domain name"
}

variable "records" {
  type = map(object({
    name     = string,
    value    = string,
    type     = string,
    priority = number
  }))
  description = "Additional domain records"
  default = {}
}
