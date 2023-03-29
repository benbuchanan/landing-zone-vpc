##############################################################################
# Resource Group
# (if var.resource_group is null, create a new RG using var.prefix)
##############################################################################

resource "ibm_resource_group" "resource_group" {
  count    = local.resource_group != null ? 0 : 1
  name     = "${local.prefix}-rg"
  quota_id = null
}

data "ibm_resource_group" "existing_resource_group" {
  count = local.resource_group != null ? 1 : 0
  name  = local.resource_group
}

#############################################################################
# Provision VPC
#############################################################################

module "slz_vpc" {
  source = "../../"

  resource_group_id = local.resource_group != null ? data.ibm_resource_group.existing_resource_group[0].id : ibm_resource_group.resource_group[0].id
  region            = local.region
  name              = local.name
  prefix            = local.prefix
  tags              = local.resource_tags
}

data "ibm_is_vpc" "vpc" {
  identifier = module.slz_vpc.vpc_id
}

#############################################################################
# Provision VSI
#############################################################################



module "slz_vsi" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vsi.git?ref=v2.0.0"

  resource_group_id = local.resource_group != null ? data.ibm_resource_group.existing_resource_group[0].id : ibm_resource_group.resource_group[0].id

  image_id                   = local.image_id
  create_security_group      = false
  security_group             = null
  tags                       = local.resource_tags
  subnets                    = module.slz_vpc.subnet_zone_list
  vpc_id                     = module.slz_vpc.vpc_id
  prefix                     = local.prefix
  machine_type               = local.machine_type
  user_data                  = null
  boot_volume_encryption_key = null
  vsi_per_subnet             = local.vsi_per_subnet
  ssh_key_ids                = [var.ssh_key_id]
  enable_floating_ip         = local.vsi_floating_ip
}

#############################################################################
# Configure overrides
#############################################################################

data "ibm_cm_preset" "preset_configuration" {
  provider = catalog
  count    = var.preset_id != "" && var.preset_id != null ? 1 : 0
  id       = var.preset_id
}

locals {
  override = {
    vars             = jsondecode("{}")
    preset_overrides = jsondecode(var.preset_id != "" ? data.ibm_cm_preset.preset_configuration[0].preset : "{}")
  }
  override_type = var.preset_id != "" && var.preset_id != null ? "preset_overrides" : "vars"

  region          = lookup(local.override[local.override_type], "region", var.region)
  prefix          = lookup(local.override[local.override_type], "prefix", var.prefix)
  name            = lookup(local.override[local.override_type], "name", var.name)
  resource_group  = lookup(local.override[local.override_type], "resource_group", var.resource_group)
  resource_tags   = lookup(local.override[local.override_type], "resource_tags", var.resource_tags)
  machine_type    = lookup(local.override[local.override_type], "machine_type", var.machine_type)
  image_id        = lookup(local.override[local.override_type], "image_id", var.image_id)
  vsi_floating_ip = lookup(local.override[local.override_type], "vsi_floating_ip", var.vsi_floating_ip)
  vsi_per_subnet  = lookup(local.override[local.override_type], "vsi_per_subnet", var.vsi_per_subnet)
}
