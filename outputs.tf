output "name" {
  value       = azurerm_virtual_wan.main.name
  description = "Virtual WAN name"
}

output "resource_group_name" {
  value       = azurerm_virtual_wan.main.resource_group_name
  description = "Virtual WAN resource group name"
}

output "subscription_id" {
  value       = data.azurerm_subscription.main.subscription_id
  description = "Virtual WAN subscription ID"
}

output "private_dns_zones" {
  value       = [azurerm_private_dns_zone.main[*].name]
  description = "List of private DNS zones"
}
