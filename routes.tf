# create a route table for each subnet
resource "aws_route_table" "rtb" {
  count  = "${local.subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(
    map("Name", "${var.name} route table - ${element(local.tiers, count.index/local.az_count)} in ${element(local.azs, count.index % local.az_count)}"),
    var.tags
  )}"
}

# associate each route table with a subnet at its same spot in the list
resource "aws_route_table_association" "rta" {
  count          = "${local.subnet_count}"
  subnet_id      = "${element(aws_subnet.net.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rtb.*.id, count.index)}"
}

# every subnet should have a default route out through the IGW
resource "aws_route" "egress_ipv6" {
  count          = "${local.subnet_count}"
  route_table_id = "${element(aws_route_table.rtb.*.id, count.index)}"

  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.igw.id}"
}

resource "aws_route" "egress_ipv4_private" {
  count = "${local.subnet_count - local.az_count}"

  route_table_id = "${element(
    aws_route_table.rtb.*.id,
    (count.index < local.public_subnet_offset ? count.index : count.index + local.az_count ),
  )}"

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = "${element(aws_nat_gateway.gw.*.id, count.index % local.az_count)}"
}

resource "aws_route" "egress_ipv4_public" {
  count = "${local.az_count}"

  route_table_id = "${element(aws_route_table.rtb.*.id, count.index + local.public_subnet_offset)}"

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = "${aws_internet_gateway.igw.id}"
}
