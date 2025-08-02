terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
    rhcs = {
      version = ">= 1.6.9"
      source  = "terraform-redhat/rhcs"
    }
    #rhcs = {
    #  source  = "terraform.local/local/rhcs"
    #  version = "1.6.9"
    #}
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
    shell = {
      source = "scottwinkler/shell"
      version = ">= 1.7.10"
    }
    http = {
      source = "hashicorp/http"
      version = ">= 3.4.5"
    }
  }
}
