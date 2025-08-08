/**
 * # Zesty Kompass Insights Azure Module
 *
 * This module provisions Azure Active Directory (Azure AD) Applications,
 * Service Principals, and custom Role Definitions required for Kompass Insights.
 *
 * ## Features:
 *
 * - Creates an Azure AD Application and Service Principal.
 * - Optionally creates a Service Principal password (client secret).
 * - Creates a custom Azure Role Definition assigned to the Service Principal.
 *
 * ## Prerequisites
 *
 * - Azure Subscription
 *
 * ## Quick Start
 *
 * To create necessary cloud resources for Kompass Insights:
 *
 * ```hcl
 * module "kompass_insights" {
 *   source = "TODO"
 *
 *   # Create a Service Principal password (client secret)
 *   create_service_principal_password = true
 * }
 * ```
 *
 * This module creates all necessary cloud resources for Kompass Insights.
 *
 * ## Service Principal Password (client secret)
 *
 * Kompass Insights requires Service Principals password to access Azure resources.
 * You can create a Service Principal password (client secret) by setting the `create_service_principal_password` variable to `true`.
 * To read the password, run the following command:
 *
 * ```bash
 * terraform output -raw service_principal_password
 * ```
 *
 * Optionally you can create a Service Principal password (client secret) manually in Azure Portal or by using the following command:
 *
 * ```bash
 * az ad app credential reset --id $(terraform output -raw application_client_id) --query password --output tsv
 * ```
 *
 */


data "azuread_client_config" "current" {
  count = var.create ? 1 : 0
}
data "azurerm_subscription" "current" {
  count = var.create ? 1 : 0
}

locals {
  current_object_id       = try(data.azuread_client_config.current[0].object_id, null)
  current_subscription_id = try(data.azurerm_subscription.current[0].id, null)

  create_service_principal          = var.create && var.create_service_principal
  create_service_principal_password = local.create_service_principal && var.create_service_principal_password
  create_role                       = var.create && var.create_role

  # Tags used for all resources
  tags = {
    Zesty = "true"
  }
}

################################################################################
# Kompass Insights Azure AD Service Principal
################################################################################

locals {
  service_principal_owners = var.service_principal_owner_use_current_identity ? concat([local.current_object_id], var.service_principal_owners) : var.service_principal_owners
  service_principal_tags   = [for k, v in merge(local.tags, var.tags) : "${k}:${v}"]
}

resource "azuread_application" "this" {
  count = local.create_service_principal ? 1 : 0

  display_name = var.service_principal_application_name
  owners       = local.service_principal_owners

  tags = local.service_principal_tags
}

resource "azuread_application_password" "this" {
  count = local.create_service_principal_password ? 1 : 0

  application_id      = azuread_application.this[0].id
  display_name        = var.service_principal_password_display_name
  start_date          = var.service_principal_password_start_date
  end_date            = var.service_principal_password_end_date
  end_date_relative   = var.service_principal_password_end_date_relative
  rotate_when_changed = var.service_principal_password_rotate_when_changed
}

resource "azuread_service_principal" "this" {
  count = local.create_service_principal ? 1 : 0

  client_id = azuread_application.this[0].client_id
  owners    = local.service_principal_owners

  tags = local.service_principal_tags
}

################################################################################
# Kompass Insights Subscription Role
################################################################################

resource "azurerm_role_definition" "this" {
  count = local.create_role ? 1 : 0

  name        = var.role_name
  description = var.role_description
  scope       = var.role_scope == null ? local.current_subscription_id : var.role_scope

  # From: https://opencost.io/docs/configuration/azure/
  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/vmSizes/read",
      "Microsoft.Resources/subscriptions/locations/read",
      "Microsoft.Resources/providers/read",
      "Microsoft.ContainerService/containerServices/read",
      "Microsoft.Commerce/RateCard/read"
    ]
  }

  assignable_scopes = var.role_assignable_scopes == null ? [local.current_subscription_id] : var.role_assignable_scopes
}

resource "azurerm_role_assignment" "this" {
  count = local.create_service_principal && local.create_role ? 1 : 0

  scope              = var.role_scope == null ? local.current_subscription_id : var.role_scope
  description        = var.role_assignment_description
  role_definition_id = azurerm_role_definition.this[0].role_definition_resource_id
  principal_id       = azuread_service_principal.this[0].object_id
}
