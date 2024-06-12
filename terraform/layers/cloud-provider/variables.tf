variable "cluster_name" {
  type    = string
  default = "default_cluster"
}
variable "cluster_version" {
  type = string
}
variable "node_pool_name" {
  type = string
}
variable "node_pool_size" {
  type = string
}
variable "node_count_min" {
  type = number
}
variable "node_count_desired" {
  type = number
}
variable "node_count_max" {
  type = number
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "cidr" {
  type = string
}
variable "ecr_name" {
  type = string
}
