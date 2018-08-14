# IPv6 VPC

Creates an AWS VPC with IPv6 enabled. Subnets are routes are laid out with
appropriate CIDR blocks with a single public set of subnets.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `name` | Name for the VPC | string | - | yes |
| `tiers` | A list of tier labels | list | - | yes |
| `public_tier` | The tier label which should accept traffic inbound from the public internet | string | - | yes |
| `azs` | List of Availability Zones to use. The default is an empty list, in which case all AZs in the region will be used. | list | `<list>` | no |
| `ipv4_cidr_block` | IPv4 CIDR Block to use for the VPC (required by AWS) | string | `10.0.0.0/16` | no |
| `enable_classiclink` | A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. See the [ClassicLink documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html) for more information. Defaults `false`. | string | `false` | no |
| `enable_classiclink_dns_support` | A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic. | string | `false` | no |
| `enable_dns_hostnames` | A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false`. | string | `false` | no |
| `enable_dns_support` | A boolean flag to enable/disable DNS support in the VPC. Defaults `true`. | string | `true` | no |
| `instance_tenancy` | A tenancy option for instances launched into the VPC | string | `default` | no |
| `tags` | Tags to apply to all taggable resources | map | `<map>` | no |

The `public_tier` does not have to exist in the `tiers` list. The module will
append `public_tier` to `tiers`, and then sort the list and remove duplicates.
The result is a canonical list of tier labels.

## Outputs

| Name | Description |
|------|-------------|
| `az_nat_gateways` | Map of AZ name to the NAT Gateway in that AZ |
| `azs` | List of AZ names as used by the module. (If the input for AZs was empty, the module finds a list of all AZs in the region) |
| `tier_route_tables` | Map of tier label to a list of route tables in that tier. Route table lists are in AZ order. |
| `tier_subnets` | Map of tier label to a list of subnets in that tier. Subnet lists are in AZ order. |
| `tiers` | List of tier labels as used by the module. This is a sorted distinct list formed by appending the public tier label to the list of other tiers. |
| `vpc` | ID of the VPC that is managed by this module |

`tier_route_tables` and `tier_subnets` are both maps of lists, where the map
keys are the tier labels and the lists are resources that belong to the tier.
The lists themselves are sorted by AZ. This allows looking up resources by tier
and AZ.

