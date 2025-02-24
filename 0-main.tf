#terraform {
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = ">= 4.20.0"
#    }
#    rhcs = {
#      version = "= 1.6.8"
#      source  = "terraform-redhat/rhcs"
#    }
#  }
#}

# Export token using the RHCS_TOKEN environment variable
provider "rhcs" {}

provider "aws" {
  region = var.aws_region
  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
  default_tags {
    tags = var.default_aws_tags
  }
}

data "aws_availability_zones" "available" {}

locals {
  # Extract availability zone names for the specified region, limit it to 3 if multi az or 1 if single
  region_azs = var.multi_az ? slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 3) : slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 1)
}

#resource "random_string" "random_name" {
#  length  = 6
#  special = false
#  upper   = false
#}

locals {
  worker_node_replicas = var.multi_az ? 3 : 2
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  #cluster_name = coalesce(var.cluster_name, "rosa-\${random_string.random_name.result}")
  cluster_name = var.cluster_name
}

# The network validator requires an additional 60 seconds to validate Terraform clusters.
#resource "time_sleep" "wait_60_seconds" {
#  count = var.create_vpc ? 1 : 0
#  depends_on = [module.vpc]
#  create_duration = "60s"
#}

module "rosa-hcp" {
  source                 = "terraform-redhat/rosa-hcp/rhcs"
  version                = "1.6.5"
  aws_billing_account_id = "604574367752"
  cluster_name           = local.cluster_name
  openshift_version      = var.openshift_version
  account_role_prefix    = local.cluster_name
  operator_role_prefix   = local.cluster_name
  replicas               = local.worker_node_replicas
  aws_availability_zones = local.region_azs
  create_oidc            = true
  private                = var.private_cluster
  #aws_subnet_ids         = var.aws_subnet_ids
  #aws_subnet_ids         = data.aws_subnets.subnets.ids
  aws_subnet_ids         = concat(slice(data.aws_subnets.public_subnets.ids, 0, 1), slice(data.aws_subnets.private_subnets.ids, 0, 3))

  create_account_roles   = true
  create_operator_roles  = true
  create_admin_user      = true
  admin_credentials_username = var.admin_credentials_username
  admin_credentials_password = var.admin_credentials_password


  identity_providers = {
    htpasswd-idp = {
      name               = "htpasswd-idp"
      idp_type           = "htpasswd"
      htpasswd_idp_users = jsonencode([{ username = "test-user", password =  "Some-Complicated-123-Password"}])
    }
  }
}

#module "htpasswd_idp" {
#  source = "terraform-redhat/rosa-hcp/rhcs//modules/idp"
#
#  cluster_id         = module.rosa-hcp.cluster_id
#  name               = "htpasswd-idp"
#  idp_type           = "htpasswd"
#  htpasswd_idp_users = jsonencode( 
#    [
#      { username = "some-user", 
#        password = "Some-Complicated-123-Password"
#      }
#    ]
#  )
#}
