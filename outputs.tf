output "vpc" {
  value = "${aws_vpc.vpc.id}"
}

output "az_nat_gateways" {
  value = "${zipmap(local.azs, aws_nat_gateway.gw.*.id)}"
}

output "tier_subnets" {
  value = "${zipmap(local.tiers, chunklist(aws_subnet.net.*.id, local.az_count))}"
}

output "tier_route_tables" {
  value = "${zipmap(local.tiers, chunklist(aws_route_table.rtb.*.id, local.az_count))}"
}

output "azs" {
  value = ["${local.azs}"]
}

output "tiers" {
  value = ["${local.tiers}"]
}
