variable "openshift_version" {
  type        = string
  #default     = "4.16.35"
  default     = "4.18.12"
  description = "Desired version of OpenShift for the cluster, for example '4.14.20'. If version is greater than the currently running version, an upgrade will be scheduled."
}

variable "properties" {
  type        = map(string)
  description = "user definerd properties for hcp"
  default     = {
    zero_egress = true
  }
}

#variable "create_vpc" {
#  type        = bool
#  description = "If you would like to create a new VPC, set this value to 'true'. If you do not want to create a new VPC, set this value to 'false'."
#  default     = "false"
#}

# ROSA Cluster info
variable "cluster_name" {
  default     = "this-cluster"
  type        = string
  description = "The name of the ROSA cluster to create"
}

variable "rosa_api_token" {
  default     = ""
  type        = string
  description = "ocm token to access console.redhat.com"
}

variable "admin_credentials_username" {
  default     = "cluster-admin"
  type        = string
  description = "Set this on the command line via env var 'export TF_VAR_admin_credentials_username='cluster-admin'"
}

variable "admin_credentials_password" {
  default     = null
  type        = string
  description = "Set this on the command line via env var 'export TF_VAR_admin_credentials_password='some_password'"
}

variable "compute_machine_type" {
  type        = string
  default     = "m5.xlarge"
  description = "Identifies the Instance type used by the default worker machine pool e.g. `m5.xlarge`. Use the `rhcs_machine_types` data source to find the possible values."
}

#variable "additional_tags" {
#  default = {
#    Terraform   = "true"
#    Environment = "dev"
#  }
#  description = "Additional AWS resource tags"
#  type        = map(string)
#}

variable "multi_az" {
  type        = bool
  description = "Multi AZ Cluster for High Availability"
  default     = true
}

variable "replicas" {
  default     = 3
  description = "Number of worker nodes to provision. Single zone clusters need at least 2 nodes, multizone clusters need at least 3 nodes"
  type        = number
}

variable "aws_subnet_ids" {
  type        = list(any)
  description = "A list of either the public or public + private subnet IDs to use for the cluster blocks to use for the cluster"
  default     = ["subnet-045a40da0e39082af","subnet-087737d06bb97acaf","subnet-02c0f5e2c09ad7159","subnet-0b9b7f46856ac8a9f","subnet-06a8f5c8f7d04082f","subnet-0fc71601f1a497c26"]
}

variable "private_cluster" {
  type        = bool
  description = "If you want to create a private cluster, set this value to 'true'. If you want a publicly available cluster, set this value to 'false'."
  default     = false
}

#VPC Info
#variable "vpc_name" {
#  type        = string
#  description = "VPC Name"
#  default     = "tf-qs-vpc"
#}

#variable "vpc_cidr_block" {
#  type        = string
#  description = "value of the CIDR block to use for the VPC"
#  default     = "10.0.0.0/16"
#}

#variable "private_subnet_cidrs" {
#  type        = list(any)
#  description = "The CIDR blocks to use for the private subnets"
#  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#}

#variable "public_subnet_cidrs" {
#  type        = list(any)
#  description = "The CIDR blocks to use for the public subnets"
#  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
#}

#variable "single_nat_gateway" {
#  type        = bool
#  description = "Single NAT or per NAT for subnet"
#  default     = false
#}

#AWS Info
variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "default_aws_tags" {
  type        = map(string)
  description = "Default tags for AWS"
  default     = {}
}

#variable "autoscaling" {
#  type = object({
#    enabled      = bool
#    min_replicas = number
#    max_replicas = number
#  })
#  default = {
#    enabled      = false
#    min_replicas = null
#    max_replicas = null
#  }
#  nullable    = false
#  description = "Configures autoscaling for the pool."
#}

#variable "terraform_state_bucket" {
#  type        = string
#  default     = "rosa-hcp-state"
#  description = "defautl state bucket for the aws environment"
#}

#######
variable "cluster_autoscaler_enabled" {
  type        = bool
  default     = true
  description = "Enable Autoscaler for this cluster. This resource is currently unavailable and using will result in error 'Autoscaler configuration is not available'"
}

variable "autoscaler_max_pod_grace_period" {
  type        = number
  default     = 600
  #default     = null
  description = "Gives pods graceful termination time before scaling down."
}

variable "autoscaler_pod_priority_threshold" {
  type        = number
  default     = -10
  #default     = null
  description = "To allow users to schedule 'best-effort' pods, which shouldn't trigger Cluster Autoscaler actions, but only run when there are spare resources available."
}

variable "autoscaler_max_node_provision_time" {
  type        = string
  default     = "15m"
  #default     = null
  description = "Maximum time cluster-autoscaler waits for node to be provisioned."
}

variable "autoscaler_max_nodes_total" {
  type        = number
  default     = 9
  #default     = null
  description = "Maximum number of nodes in all node groups. Cluster autoscaler will not grow the cluster beyond this number."
}

variable "labels" {
  description = "Labels for the machine pool. Format should be a comma-separated list of 'key = value'. This list will overwrite any modifications made to node labels on an ongoing basis."
  type        = map(string)
  default     = null
}

variable "taints" {
  description = "Taints for a machine pool. This list will overwrite any modifications made to node taints on an ongoing basis."
  type = list(object({
    key           = string
    value         = string
    schedule_type = string
  }))
  default = null
}

variable "machine_pools" {
  type = map(any)
  default     = {}
  description = "Provides a generic approach to add multiple machine pools after the creation of the cluster. This variable allows users to specify configurations for multiple machine pools in a flexible and customizable manner, facilitating the management of resources post-cluster deployment. For additional details regarding the variables utilized, refer to the [machine-pool sub-module](./modules/machine-pool). For non-primitive variables (such as maps, lists, and objects), supply the JSON-encoded string."
}

#variable "machine_pools" {
#  default = {}
#  type = map(object({
#    name = string
#    aws_node_pool = object({
#      instance_type                 = string
#      additional_security_group_ids = list(string)
#      tags                          = map(string)
#    })
#    autoscaling = optional(object({
#      enabled      = optional(bool)
#      min_replicas = optional(string)
#      max_replicas = optional(string)
#    }))
#    auto_repair           = optional(bool)
#    replicas              = optional(number)
#    openshift_version     = string
#    subnet_id             = string
#    ignore_deletion_error = optional(bool)
#    kubelet_configs       = optional(string)
#    labels                = optional(map(string))
#    taints = optional(list(object({
#      key           = optional(string)
#      value         = optional(string)
#      schedule_type = optional(string)
#    })))
#    tuning_configs               = optional(list(string))
#    upgrade_acknowledgements_for = optional(string)
#  }))
#  description = "map of machine pools to create generated from the json input file."
#}
