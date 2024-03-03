variable "spec" {
  type = object({
    version     = string
    environment = string
    region      = string
    location    = string
    locations   = list(string)
  })
  description = "Object containing virtual WAN configuration"
}
