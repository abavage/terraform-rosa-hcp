terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
    rhcs = {
      version = ">= 1.6.8"
      source  = "terraform-redhat/rhcs"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
  }
}
