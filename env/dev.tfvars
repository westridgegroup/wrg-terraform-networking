#####################
#Bootstrap Variables# 
#####################
state_container_name = "terraform-state"
state_key            = "terraform.tfstate.dev.wrg-terraform-networking"


##################################################
#Regular Terraform Environment Specific Variables#
##################################################
machine_number = "001"

rg_prefix = "dev"
env_tags = {
  env      = "development",
  solution = "wrg-terraform-networking"
}
