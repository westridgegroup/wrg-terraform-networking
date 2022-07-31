# WRG-TERRAFORM-NETWORK

Creates two VNETS connectived via a VPN

## Resources Created
- OnPrem Resource Group
    - OnPrem VNET
        - GatewaySubnet
        - Secondary Subnet
    - Virutal Network Gateway
    - Connection (OnPrem to Hub)
    - Public IP for Virtual Network Gateway 

- Hub Resource Group
    - Hub VNET
        - GatewaySubnet
        - Secondary Subnet
    - Virutal Network Gateway
    - Connection (Hub to OnPrem)
    - Public IP for Virtual Network Gateway

## Execution
#![Simple Test Resoruce Groups](../rg.png)

```
source env/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply -var-file env/dev.tfvars

```

