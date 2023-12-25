# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
module "naming" {
  source = "Azure/naming/azurerm"
  suffix = ["mega", var.configuration.name, var.configuration.location]
}

resource "azurerm_resource_group" "mega" {
  name     = module.naming.resource_group.name
  location = var.configuration.location
  tags     = local.tags
}

resource "azurerm_user_assigned_identity" "policy" {
  name                = "${module.naming.user_assigned_identity.name}-policy"
  resource_group_name = azurerm_resource_group.mega.name
  location            = azurerm_resource_group.mega.location
}

resource "azurerm_role_assignment" "policy_resource_group_contributor" {
  principal_id         = azurerm_user_assigned_identity.policy.principal_id
  scope                = azurerm_resource_group.mega.id
  role_definition_name = "Contributor"
}

# resource "azurerm_resource_group_policy_assignment" "modify_tags" {
#   for_each             = local.tags
#   name                 = "Add or replace a tag on resource groups"
#   location             = azurerm_resource_group.mega.location
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d157c373-a6c4-483d-aaad-570756956268"
#   resource_group_id    = azurerm_resource_group.mega.id
#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.policy.id]
#   }
#   parameters = jsonencode({
#     tagName = {
#       value = each.key
#     }
#     tagValue = {
#       value = each.value
#     }
#   })
# }

# resource "azurerm_resource_group_policy_assignment" "inherit_tags" {
#   for_each             = local.tags
#   name                 = "Add or replace a tag on resource groups"
#   location             = azurerm_resource_group.mega.location
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cd3aa116-8754-49c9-a813-ad46512ece54"
#   resource_group_id    = azurerm_resource_group.mega.id
#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.policy.id]
#   }
#   parameters = jsonencode({
#     tagName = {
#       value = each.key
#     }
#   })
# }

resource "azurerm_virtual_wan" "mega" {
  name                              = module.naming.virtual_wan.name
  resource_group_name               = azurerm_resource_group.mega.name
  location                          = azurerm_resource_group.mega.location
  type                              = "Standard"
  allow_branch_to_branch_traffic    = false
  disable_vpn_encryption            = false
  office365_local_breakout_category = "None"
}

module "hubs" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.configuration.cidrs.hubs
  networks        = [for hub in var.configuration.hubs : { name : hub, new_bits : local.mask_bits.hub - tonumber(split("/", var.configuration.cidrs.hubs).1) }]
}

module "networks_v4" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.configuration.cidrs.networks.0
  networks        = [for hub in var.configuration.hubs : { name : hub, new_bits : local.mask_bits.network.0 - tonumber(split("/", var.configuration.cidrs.networks.0).1) }]
}

module "networks_v6" {
  source          = "hashicorp/subnets/cidr"
  base_cidr_block = var.configuration.cidrs.networks.1
  networks        = [for hub in var.configuration.hubs : { name : hub, new_bits : local.mask_bits.network.1 - tonumber(split("/", var.configuration.cidrs.networks.1).1) }]
}
