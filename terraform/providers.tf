provider "kubernetes" {
  host                   = module.cloud-provider.cluster_endpoint
  token                  = module.cloud-provider.cluster_token
  cluster_ca_certificate = base64decode(module.cloud-provider.cluster_ca_certificate)
}

provider "kubectl" {
  load_config_file       = false
  host                   = module.cloud-provider.cluster_endpoint
  token                  = module.cloud-provider.cluster_token
  cluster_ca_certificate = base64decode(module.cloud-provider.cluster_ca_certificate)
  apply_retry_count      = 5
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

provider "helm" {
  kubernetes {
    host                   = module.cloud-provider.cluster_endpoint
    token                  = module.cloud-provider.cluster_token
    cluster_ca_certificate = base64decode(module.cloud-provider.cluster_ca_certificate)
  }
}
