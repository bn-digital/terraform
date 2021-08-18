variable "project" {
  type        = string
  description = "Project name. Used as Cluster/VPC/Space names as well"
}
variable "environment" {
  type    = string
  default = "production"
}
variable "cluster_region" {
  type    = string
  default = "lon1"
}
variable "spaces_region" {
  type    = string
  default = "ams3"
}
variable "cluster_node_size" {
  type    = string
  default = "s-2vcpu-4gb-intel"
}
variable "cluster_node_count" {
  type    = number
  default = 1
}
variable "cluster_version" {
  type    = string
  default = "1.21"
}