data "aws_availability_zones" "available" {
  count = "${length(var.azs) == 0 ? 1 : 0}"
}
