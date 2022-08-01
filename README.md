# WRG-TERRAFORM-NETWORK

Creates two VNETS connected via a VPN

## Resources Created
- OnPrem Resource Group
    - OnPrem VNET
        - GatewaySubnet
        - Secondary Subnet
    - Virutal Network Gateway
    - Connection (OnPrem to Hub)
    - Public IP for Virtual Network Gateway 
    - ToDo: Azure Firewall for DNS
    - ToDo: Blob Storage
    - ToDo: Private End Point
    - ToDo: Private DNS (for private end point)
- Hub Resource Group
    - Hub VNET
        - GatewaySubnet
        - DNS Subnet
        - VM Subnet
    - Virutal Network Gateway
    - Connection (Hub to OnPrem)
    - Public IP for Virtual Network Gateway
    - Linux VM in Secondary Subnet
    - ToDo: Public IP for Linux VM
    - ToDo: NSG for Linux VM
    - ToDo: Linux DNS Server
    - ToDO NSG for Linux DNS Server

## Execution
#![Simple Test Resoruce Groups](../rg.png)

```
source env/TerraformAzureBootstrap.sh -f env/dev.tfvars
terraform apply -var-file env/dev.tfvars

```

