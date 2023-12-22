output "name" {
  value = azurerm_virtual_wan.mega.name
}

output "resource_group_name" {
  value = azurerm_virtual_wan.mega.resource_group_name
}

output "subscription_id" {
  value = data.azurerm_subscription.mega.subscription_id
}

output "cidrs" {
  value = {
    for hub in var.configuration.hubs : hub => {
      hub : module.hubs.network_cidr_blocks[hub]
      networks : [module.networks_v4.network_cidr_blocks[hub], module.networks_v6.network_cidr_blocks[hub]]
    }
  }
}
