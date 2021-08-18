variable "domain_name" {
  type        = string
  description = "Main domain name"
}
variable "loadbalancer_public_ip" {
  type        = string
  description = "Load Balancer public IP"
}
variable "domain_records" {
  type =    map(object({
    name =  string,
    value = string,
    type =  string
  }))
  default = {}
}
