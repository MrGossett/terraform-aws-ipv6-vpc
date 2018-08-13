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
