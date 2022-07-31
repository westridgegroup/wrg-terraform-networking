# WRG-TERRAFORM-NETWORK

Creates two VNETS connectived via a VPN

## Resources Created
- OnPrem Resource Group
    - OnPrem VNET
        - GatewaySubnet
        - Secondary Subnet
    - Virutal Network Gateway
    - Virtual Network Gateway Connection
    - Public IP for Virtual Network Gateway (OnPrem to Hub)

- Hub Resource Group
    - Hub VNET
        - GatewaySubnet
        - Secondary Subnet
    - Virutal Network Gateway
    - Virtual Network Gateway Connection (Hub to OnPrem)

## Execution
#![Simple Test Resoruce Groups](../rg.png)

```
source env/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply -var-file env/dev.tfvars

```

