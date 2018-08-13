locals {
  tiers    = ["${sort(compact(distinct(concat(var.tiers, list(var.public_tier)))))}"]
  azs      = "${sort(coalescelist(var.azs, data.aws_availability_zones.available.names))}"
  az_count = "${length(local.azs)}"

  subnet_count = "${length(local.tiers) * local.az_count}"
  cidr_bits    = "${ceil(log(length(local.tiers) * local.az_count, 2))}"

  public_subnet_offset = "${local.az_count * index(local.tiers, var.public_tier)}"
}
