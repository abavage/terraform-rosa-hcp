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
    tags = local.tags
  }
}



#data "aws_availability_zones" "available" {}

#locals {
  # Extract availability zone names for the specified region, limit it to 3 if multi az or 1 if single
#  region_azs = var.multi_az ? slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 3) : slice([for zone in data.aws_availability_zones.available.names : format("%s", zone)], 0, 1)
#}

#resource "random_string" "random_name" {
#  length  = 6
#  special = false
#  upper   = false
#}

#locals {
#  worker_node_replicas = var.multi_az ? 3 : 2
  # If cluster_name is not null, use that, otherwise generate a random cluster name
  #cluster_name = coalesce(var.cluster_name, "rosa-\${random_string.random_name.result}")
#  cluster_name = var.cluster_name
#}

# The network validator requires an additional 60 seconds to validate Terraform clusters.
#resource "time_sleep" "wait_60_seconds" {
#  count = var.create_vpc ? 1 : 0
#  depends_on = [module.vpc]
#  create_duration = "60s"
#}

module "rosa-hcp" {
  source                 = "terraform-redhat/rosa-hcp/rhcs"
  version                = "1.6.9"
  aws_billing_account_id = "604574367752"
  cluster_name           = var.cluster_name
  openshift_version      = var.openshift_version
  account_role_prefix    = var.cluster_name
  operator_role_prefix   = var.cluster_name
  replicas               = var.replicas
  aws_availability_zones = local.aws_zones
  create_oidc            = true
  private                = var.private_cluster
  #aws_subnet_ids         = concat(slice(data.aws_subnets.public_subnets.ids, 0, 1), slice(data.aws_subnets.private_subnets.ids, 0, 3))
  aws_subnet_ids          = local.rosa_subnet_ids
  compute_machine_type   = var.compute_machine_type
  tags                   = local.tags 

  create_account_roles   = true
  create_operator_roles  = true
  create_admin_user      = true
  admin_credentials_username = var.admin_credentials_username
  admin_credentials_password = random_string.random.result
  
  cluster_autoscaler_enabled         = var.cluster_autoscaler_enabled
  autoscaler_max_pod_grace_period    = var.autoscaler_max_pod_grace_period
  autoscaler_pod_priority_threshold  = var.autoscaler_pod_priority_threshold
  autoscaler_max_node_provision_time = var.autoscaler_max_node_provision_time
  autoscaler_max_nodes_total         = var.autoscaler_max_nodes_total
  

  identity_providers = {
    
    htpasswd-idp = {
      name               = "htpasswd-idp"
      idp_type           = "htpasswd"
      htpasswd_idp_users = jsonencode([{ username = "test-user", password =  "Some-Complicated-123-Password"}])
    }
  #  openid-idp = {
  #    name                                 = "openid-idp"
  #    idp_type                             = "openid"
  #    openid_idp_client_id                 = "123456789"     # replace with valid <client-id>
  #    openid_idp_client_secret             = "123456789" # replace with valid <client-secret>
  #    openid_idp_ca                        = ""
  #    openid_idp_issuer                    = "https://example.com"
  #    openid_idp_claims_groups             = jsonencode(["group"])
  #    openid_idp_claims_email              = jsonencode(["email"])
  #    openid_idp_claims_preferred_username = jsonencode(["preferred_username"])
  #    #openid_idp_claims_preferred_username = "[\"preferred_username\"]"
  #    openid_idp_extra_scopes              = jsonencode(["email","profile"])
  #  }
  }

  machine_pools = {
    pool-0 = {
      name = "pool-0"
      aws_node_pool = {
        instance_type = "m5.xlarge"
        tags = local.tags
        additional_security_group_ids = null
      }
      labels      = local.labels
      taints      = local.taints
      #autoscaling = {
      #  enabled        = true
      #  min_replicas   = 0
      #  max_replicas   = 0
      #}
      auto_repair = true
      replicas = 0
      openshift_version = var.openshift_version
      subnet_id = data.aws_subnets.private_subnets.ids[0]
    }
    pool-1 = {
      name = "pool-1"
      aws_node_pool = {
        instance_type = "m5.xlarge"
        tags = local.tags
        additional_security_group_ids = null
      }
      labels      = local.labels
      taints      = local.taints
      #autoscaling = {
      #  enabled        = true
      #  min_replicas   = 0
      #  max_replicas   = 0
      #}
      auto_repair = true
      replicas = 0
      openshift_version = var.openshift_version
      subnet_id = data.aws_subnets.private_subnets.ids[1]
    }
    pool-2 = {
      name = "pool-2"
      aws_node_pool = {
        instance_type = "m5.xlarge"
        tags = local.tags
        additional_security_group_ids = null
      }
      labels      = local.labels
      taints      = local.taints
      #autoscaling = {
      #  enabled        = true
      #  min_replicas   = 0
      #  max_replicas   = 0
      #}
      auto_repair = true
      replicas = 0
      openshift_version = var.openshift_version
      subnet_id = data.aws_subnets.private_subnets.ids[2]
    }
  }
}

resource "random_string" "random" {
  length = 16
  special = false
  numeric = true
  min_numeric = 2
  min_lower   = 4
  min_upper   = 4
}



#module "rhcs_hcp_machine_pool" {
  #source   = "git::https://github.com/terraform-redhat/terraform-rhcs-rosa-hcp.git//modules/machine-pool"
#  source   = "terraform-redhat/rosa-hcp/rhcs//modules/machine-pool"
#  for_each = var.machine_pools

#  cluster_id                   = try(module.rosa-hcp.cluster_id, "dummy")
#  name                         = each.value.name
#  auto_repair                  = try(each.value.auto_repair, null)
#  autoscaling                  = try(each.value.autoscaling, null)
#  aws_node_pool                = each.value.aws_node_pool
#  openshift_version            = try(each.value.openshift_version, null)
#  tuning_configs               = try(each.value.tuning_configs, null)
#  upgrade_acknowledgements_for = try(each.value.upgrade_acknowledgements_for, null)
#  replicas                     = try(each.value.replicas, null)
#  taints                       = try(each.value.taints, null)
#  labels                       = try(each.value.labels, null)
#  subnet_id                    = each.value.subnet_id
#  kubelet_configs              = try(each.value.kubelet_configs, null)
#  ignore_deletion_error        = try(each.value.ignore_deletion_error, false)
#}



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
