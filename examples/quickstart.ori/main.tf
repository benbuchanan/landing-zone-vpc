##############################################################################
# Resource Group
# (if var.resource_group is null, create a new RG using var.prefix)
##############################################################################

resource "ibm_resource_group" "resource_group" {
  count    = var.resource_group != null ? 0 : 1
  name     = "${var.prefix}-rg"
  quota_id = null
}

data "ibm_resource_group" "existing_resource_group" {
  count = var.resource_group != null ? 1 : 0
  name  = var.resource_group
}

#############################################################################
# Provision VPC
#############################################################################

module "slz_vpc" {
  #source = "../../"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=v4.2.0"

  resource_group_id = var.resource_group != null ? data.ibm_resource_group.existing_resource_group[0].id : ibm_resource_group.resource_group[0].id
  region            = var.region
  name              = var.name
  prefix            = var.prefix
  tags              = var.resource_tags
}

data "ibm_is_vpc" "vpc" {
  identifier = module.slz_vpc.vpc_id
}

#############################################################################
# Provision VSI
#############################################################################



module "slz_vsi" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vsi.git?ref=v2.0.0"

  resource_group_id = var.resource_group != null ? data.ibm_resource_group.existing_resource_group[0].id : ibm_resource_group.resource_group[0].id

  image_id                   = var.image_id
  create_security_group      = false
  security_group             = null
  tags                       = var.resource_tags
  subnets                    = module.slz_vpc.subnet_zone_list
  vpc_id                     = module.slz_vpc.vpc_id
  prefix                     = var.prefix
  machine_type               = var.machine_type
  user_data                  = null
  boot_volume_encryption_key = null
  vsi_per_subnet             = var.vsi_per_subnet
  ssh_key_ids                = [var.ssh_key_id]
  enable_floating_ip         = var.vsi_floating_ip
}
