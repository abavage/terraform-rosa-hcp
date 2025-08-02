export RHCS_TOKEN="token..."

export TF_VAR_admin_credentials_username='cluster-admin'

export TF_VAR_admin_credentials_password='somepassword'

terraform plan -var-file="machinepools.tfvars.json"
terraform apply -var-file="machinepools.tfvars.json"

for PF. why did you split out each module and not just use the main rhcs and let it pull all individually.