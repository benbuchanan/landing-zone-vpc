variable "preset_id" {
  description = "ID of preset configuration to configure and override variables"
  type = string
  default = ""
}

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The region to which to deploy the VPC"
  type        = string
  default     = "us-south"
}

variable "prefix" {
  description = "The prefix that you would like to append to your resources"
  type        = string
  default     = "std-vpc"
}

variable "name" {
  description = "The name the VPC will be created with"
  type        = string
  default     = "solution"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  description = "List of Tags for the resource created"
  type        = list(string)
  default     = null
}

variable "machine_type" {
  description = "VSI machine type"
  type        = string
  default     = "cx2-32x64"
}

variable "image_id" {
  description = "Image ID used for VSI. Run 'ibmcloud is images' to find available images. Be aware that region is important for the image since the id's are different in each region."
  type        = string
  default     = "r134-ab47c72d-b11c-417b-a442-9f1ca6a6f5ed"
}

variable "ssh_key_id" {
  type        = string
  description = "An existing ssh key id to use"
}

variable "vsi_floating_ip" {
  description = "Add floating IP to VSIs"
  type        = bool
  default     = false
}

variable "vsi_per_subnet" {
  description = "Number of VSI instances for each subnet"
  type        = number
  default     = 1
}
