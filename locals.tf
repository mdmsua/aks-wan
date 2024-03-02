locals {
  tags = {
    module  = "wan"
    version = var.spec.version
  }
  private_dns_zones          = yamldecode(file("${path.module}/files/private_dns_zones.yaml"))
  regional_private_dns_zones = [for value in setproduct([for zone in local.private_dns_zones : zone if strcontains(zone, "*")], var.spec.locations) : replace("*", value[0], value[1])]
  all_private_dns_zones      = setunion(local.regional_private_dns_zones, [for zone in local.private_dns_zones : zone if !strcontains(zone, "*")])
}
