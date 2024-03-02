# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [var.spec.region, var.spec.environment, var.spec.location]
}

resource "azurerm_resource_group" "main" {
  name     = module.naming.resource_group.name
  location = var.spec.location
  tags     = local.tags
}

resource "azurerm_virtual_wan" "main" {
  name                              = module.naming.virtual_wan.name
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  type                              = "Standard"
  allow_branch_to_branch_traffic    = false
  disable_vpn_encryption            = false
  office365_local_breakout_category = "None"
  tags                              = local.tags
}

resource "azurerm_private_dns_zone" "main" {
  for_each            = local.all_private_dns_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}
