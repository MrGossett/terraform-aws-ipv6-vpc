module "ipv6-vpc" {
  source = "../"

  name        = "example"
  public_tier = "dmz"
  tiers       = ["app", "store", "svcs"]
}
