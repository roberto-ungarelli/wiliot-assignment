terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
  required_version = "~> 1.3"
}
