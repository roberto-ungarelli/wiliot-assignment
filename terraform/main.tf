terraform {
  backend "s3" {
  }
}

module "cloud-provider" {
  source             = "./layers/cloud-provider"
  cluster_name       = var.CLUSTER_NAME
  cluster_version    = var.CLUSTER_VERSION
  node_pool_name     = "${var.CLUSTER_NAME}-node-pool"
  node_pool_size     = var.NODE_POOL_SIZE
  node_count_min     = 1
  node_count_desired = 2
  node_count_max     = 3
  cidr               = var.CIDR
  private_subnets    = var.PRIVATE_SUBNETS
  public_subnets     = var.PUBLIC_SUBNETS
  ecr_name           = var.ECR_NAME
}

module "orchestrator" {
  source              = "./layers/orchestrator"
  cluster_issuer_mail = var.ADMIN_MAIL
  depends_on          = [module.cloud-provider]
}

module "application" {
  source               = "./layers/application"
  route_53_zone_id     = var.ROUTE_53_ZONE_ID
  loadbalancer_address = module.orchestrator.loadbalancer_address
  domain               = var.DOMAIN
  depends_on           = [module.orchestrator]
}
