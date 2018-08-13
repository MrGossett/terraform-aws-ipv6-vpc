resource "aws_vpc" "vpc" {
  cidr_block = "${var.ipv4_cidr_block}"

  assign_generated_ipv6_cidr_block = true

  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  enable_classiclink             = "${var.enable_classiclink}"
  enable_classiclink_dns_support = "${var.enable_classiclink_dns_support}"

  tags = "${merge(
    map("Name", "${var.name}"),
    var.tags
  )}"
}

resource "aws_egress_only_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
    map("Name", "${var.name} igw"),
    var.tags
  )}"
}

# visualize a grid. rows are network tiers, columns are AZs. the size of the
# grid is length(local.tiers)*local.az_count. we iterate through the grid
# left-to-right, then top-to-bottom, creating a subnet for each cell
resource "aws_subnet" "net" {
  count = "${local.subnet_count}"

  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(local.azs, count.index % local.az_count)}"

  cidr_block      = "${cidrsubnet(aws_vpc.vpc.cidr_block, local.cidr_bits, count.index)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index)}"

  map_public_ip_on_launch = "${var.public_tier == element(local.tiers, count.index/length(local.tiers)) ? "true" : "false"}"

  assign_ipv6_address_on_creation = true

  tags = "${merge(
    map(
      "Name", "${var.name} subnet - ${element(local.tiers, count.index/length(local.tiers))} in ${element(local.azs, count.index % local.az_count)}",
      "Tier", "${element(local.tiers, count.index/length(local.tiers))}",
      "AZ", "${element(local.azs, count.index % local.az_count)}",
      "Public", "${var.public_tier == element(local.tiers, count.index/length(local.tiers)) ? "true" : "false"}",
    ),
    var.tags
  )}"
}

resource "aws_eip" "nat" {
  count = "${local.az_count}"
  vpc   = true

  tags = "${merge(
    map(
      "Name", "${var.name} eip - ${var.public_tier} in ${element(local.azs, count.index % local.az_count)}",
      "Tier", "${var.public_tier}",
      "AZ", "${element(local.azs, count.index % local.az_count)}",
    ),
    var.tags
  )}"
}

resource "aws_nat_gateway" "gw" {
  count = "${local.az_count}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  subnet_id = "${
    element(
      aws_subnet.net.*.id,
      count.index/length(local.tiers) + 
        (local.az_count * index(local.tiers, var.public_tier)),
    )
  }"

  depends_on = ["aws_internet_gateway.igw"]

  tags = "${merge(
    map(
      "Name", "${var.name} natgw - ${var.public_tier} in ${element(local.azs, count.index % local.az_count)}",
      "Tier", "${var.public_tier}",
      "AZ", "${element(local.azs, count.index % local.az_count)}",
    ),
    var.tags
  )}"
}
