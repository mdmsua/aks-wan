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

variable "tfc_azure_dynamic_credentials" {
  description = "Object containing Azure dynamic credentials configuration"
  type = object({
    default = object({
      client_id_file_path  = string
      oidc_token_file_path = string
    })
    aliases = map(object({
      client_id_file_path  = string
      oidc_token_file_path = string
    }))
  })
}
