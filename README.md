# WRG-TERRAFORM-NETWORK

Creates two VNETS connectived via a VPN

## Resources Created
- OnPrem
-     OnPrem VNET
*         GatewaySubnet
*         Secondary Subnet
*     Virutal Network Gateway
*     Public IP for Virtual Network Gateway
*     Hub VNET
*         GatewaySubnet
*         Secondary Subnet
## Execution
#![Simple Test Resoruce Groups](../rg.png)

```
source env/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply -var-file env/dev.tfvars

```

