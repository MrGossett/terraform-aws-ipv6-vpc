output "vpc" {
  value       = "${aws_vpc.vpc.id}"
  description = "ID of the VPC that is managed by this module"
}

output "az_nat_gateways" {
  value       = "${zipmap(local.azs, aws_nat_gateway.gw.*.id)}"
  description = "Map of AZ name to the NAT Gateway in that AZ"
}

output "tier_subnets" {
  value       = "${zipmap(local.tiers, chunklist(aws_subnet.net.*.id, local.az_count))}"
  description = "Map of tier label to a list of subnets in that tier. Subnet lists are in AZ order."
}

output "tier_route_tables" {
  value       = "${zipmap(local.tiers, chunklist(aws_route_table.rtb.*.id, local.az_count))}"
  description = "Map of tier label to a list of route tables in that tier. Route table lists are in AZ order."
}

output "azs" {
  value       = ["${local.azs}"]
  description = "List of AZ names as used by the module. (If the input for AZs was empty, the module finds a list of all AZs in the region)"
}

output "tiers" {
  value       = ["${local.tiers}"]
  description = "List of tier labels as used by the module. This is a sorted distinct list formed by appending the public tier label to the list of other tiers."
}
