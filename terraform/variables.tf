variable "AWS_ACCESS_KEY" {
  type = string
}
variable "AWS_SECRET_KEY" {
  type = string
}
variable "AWS_REGION" {
  type = string
}
variable "CLUSTER_NAME" {
  type = string
}
variable "CLUSTER_VERSION" {
  type = string
}
variable "NODE_POOL_SIZE" {
  type = string
}
variable "ADMIN_MAIL" {
  type = string
}
variable "CIDR" {
  type = string
}
variable "PRIVATE_SUBNETS" {
  type = list(string)
}
variable "PUBLIC_SUBNETS" {
  type = list(string)
}
variable "ROUTE_53_ZONE_ID" {
  type = string
}
variable "DOMAIN" {
  type = string
}
variable "ECR_NAME" {
  type = string
}