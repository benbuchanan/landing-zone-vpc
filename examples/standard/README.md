# IBM Landing Zone VPC

[![Build Status](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc/actions/workflows/ci.yml)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

This module creates the following IBM Cloud&reg; Virtual Private Cloud (VPC) network components:

- VPC
- Public gateways
- Subnets
- Network ACLs
- VPN gateways
- VPN gateway connections
- VSIs
- Floating IPs

![vpc-module](./.docs/vpc-module.svg)

## VPC

This module creates a VPC in a resource group, and supports classic access. The VPC and components are specified in the [main.tf](main.tf) file.

---

## Public gateways

You can optionally create public gateways in the VPC in each of the three zones of the VPC's region.

---

## Network ACLs

You can create any number of network ACLs with any number of rules. By default, VPC network ACLs can have no more than 25 rules.

---

## Subnets

You can create up to three zones in the [subnet.tf](subnet.tf) file. You can optionally attach public gateways to each subnet. And you can provide an ACL as a parameter to each subnet if the ACL is created by the module.

### Address prefixes

A CIDR block is created in the VPC for each subnet that is provisioned.

### Subnets variable

The following example shows the `subnets` variable.

```terraform
object({
    zone-1 = list(object({
      name           = string
      cidr           = string
      acl_name       = string
      public_gateway = optional(bool)
    }))
    zone-2 = list(object({
      name           = string
      cidr           = string
      acl_name       = string
      public_gateway = optional(bool)
    }))
    zone-3 = list(object({
      name           = string
      cidr           = string
      acl_name       = string
      public_gateway = optional(bool)
    }))
  })
```

`zone-1`, `zone-2`, and `zone-3` are lists, but are converted to objects before the resources are provisioned. The conversion ensures that the addition or deletion of subnets affects only the added or deleted subnets, as shown in the following example.

```terraform
module.subnets.ibm_is_subnet.subnet["gcat-multizone-subnet-a"]
module.subnets.ibm_is_subnet.subnet["gcat-multizone-subnet-b"]
module.subnets.ibm_is_subnet.subnet["gcat-multizone-subnet-c"]
module.subnets.ibm_is_vpc_address_prefix.subnet_prefix["gcat-multizone-subnet-a"]
module.subnets.ibm_is_vpc_address_prefix.subnet_prefix["gcat-multizone-subnet-b"]
module.subnets.ibm_is_vpc_address_prefix.subnet_prefix["gcat-multizone-subnet-c"]
```

---

## VPN gateways

You can create any number of VPN gateways on your subnets by using the `vpn_gateways` variable. For more information about VPN gateways on VPC, see [About site-to-site VPN gateways](https://cloud.ibm.com/docs/vpc?topic=vpc-using-vpn) in the IBM Cloud docs.

---

## Usage
```terraform
module vpc {
  # Replace "master" with a GIT release version to lock into a specific release
  source                      = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=master"
  resource_group_id           = var.resource_group_id
  region                      = var.region
  prefix                      = var.prefix
  tags                        = var.tags
  vpc_name                    = var.vpc_name
  classic_access              = var.classic_access
  network_acls                = var.network_acls
  use_public_gateways         = var.use_public_gateways
  subnets                     = var.subnets
  vpn_gateways                = var.vpn_gateways
}
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.45.0 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="ibmcloud_api_key">ibmcloud_api_key</a>  | APIkey that's associated with the account to provision resources to | <pre>string</pre> | not set | not required if running on the cloud|
| <a name="region">region</a>  | The region to which to deploy the VPC | <pre>string</pre> | `us-south` | yes |
| <a name="prefix">prefix</a>  | The prefix that you would like to append to your resources | <pre>string</pre> | `us-south` | yes |
| <a name="name">name</a>  | VPC name | <pre>string</pre> | `sol-vpc` | `yes |
| <a name="resource_group">resource_group</a>  | Name for an existing resource group to attache resources to | <pre>string</pre> | not set | yes |
| <a name="machine_type">resource_group</a>  | VSI machine time | <pre>string</pre> | `cx2-2x4` | yes |
| <a name="ssh_key_id">ssh_key_id</a>  | existing registered SSH id | <pre>string</pre> | not set | yes |
| <a name="vsi_floating_ip">vsi_floating_ip</a>  | Flag designating if to create floating IP to VSIs | <pre>bool</pre> | `false` | yes |
| <a name="vsi_per_subnet">vsi_per_subnet</a>  | Number of VSI instances for each subnet | <pre>number</pre> | `1` | yes |




## Outputs

| Name | Description |
|------|-------------|
| <a name="id">id</a> | VPC's ID |
| <a name="crn">crn</a> | VPC's CRN |



<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

