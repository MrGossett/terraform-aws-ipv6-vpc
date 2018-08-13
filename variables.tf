variable "name" {
  type        = "string"
  description = "Name for the VPC"
}

variable "ipv4_cidr_block" {
  type        = "string"
  description = "IPv4 CIDR Block to use for the VPC (required by AWS)"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = "list"
  description = "List of Availability Zones to use. The default is an empty list, in which case all AZs in the region will be used."
  default     = []
}

variable "tiers" {
  type        = "list"
  description = "A list of tier labels"
}

variable "public_tier" {
  type        = "string"
  description = "The tier label which should accept traffic inbound from the public internet"
}

variable "tags" {
  type        = "map"
  description = "Tags to apply to all taggable resources"
  default     = {}
}

variable "instance_tenancy" {
  type        = "string"
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "enable_dns_support" {
  type        = "string"
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults `true`."
  default     = "true"
}

variable "enable_dns_hostnames" {
  type        = "string"
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false`."
  default     = "false"
}

variable "enable_classiclink" {
  type        = "string"
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. See the [ClassicLink documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html) for more information. Defaults `false`."
  default     = "false"
}

variable "enable_classiclink_dns_support" {
  type        = "string"
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  default     = "false"
}
