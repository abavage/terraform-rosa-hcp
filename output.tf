
output "cluster_api_url" {
  value       = module.rosa-hcp.cluster_api_url
  description = "The URL of the API server."
}

output "cluster_console_url" {
  value       = module.rosa-hcp.cluster_console_url
  description = "The URL of the console."
}

output "cluster_oidc_config_id" {
  value       = module.rosa-hcp.oidc_config_id
  description = "oidc id"
}

output "cluster_oidc_endpoint_url" {
  value       = module.rosa-hcp.oidc_endpoint_url
  description = "oidc oidc_endpoint_url"
}

output "admin_password" {
  value = nonsensitive(random_string.random.result)
}

output "account_id" {
  value = data.aws_caller_identity.current.id
}

output "region" {
  value = data.aws_region.current.id
}

output "vpc_id" {
  value = data.aws_vpc.get_rosa_vpc.id
}

output "rosa_subnet_ids" {
  value = local.rosa_subnet_ids
}

output "all_rosa_subnet_ids" {
  value = local.all_rosa_subnet_ids
}

output "test_machine_pools" {
  value = var.machine_pools
}



