variable "configuration" {
  type = object({
    version         = string
    location        = string
    tenant_id       = string
    subscription_id = string
    cidrs = object({
      hubs       = string
      networks   = list(string)
      kubernetes = string
    })
    hubs = list(string)
  })
}
