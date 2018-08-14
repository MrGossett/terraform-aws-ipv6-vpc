output "vpc" {
  value = "${module.ipv6-vpc.vpc}"
}

output "az_nat_gateways" {
  value = "${module.ipv6-vpc.az_nat_gateways}"
}

output "tier_subnets" {
  value = "${module.ipv6-vpc.tier_subnets}"
}

output "tier_route_tables" {
  value = "${module.ipv6-vpc.tier_route_tables}"
}

output "tiers" {
  value = ["${module.ipv6-vpc.tiers}"]
}

output "azs" {
  value = ["${module.ipv6-vpc.azs}"]
}
