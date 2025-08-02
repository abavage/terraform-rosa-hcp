# Export token using the RHCS_TOKEN environment variable
# export RHCS_TOKEN="..."

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
