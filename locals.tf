locals {
  tags = {
    version = var.configuration.version
    module  = "wan"
  }
  mask_bits = {
    hub : 23
    network : [
      16,
      52
    ]
  }
}
