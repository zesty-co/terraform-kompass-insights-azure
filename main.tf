/**
 * # Zesty Kompass Insights Azure Module
 *
 * This Terraform module provisions Azure Active Directory (Azure AD) Applications,
 * Service Principals, and custom Role Definitions required for Kompass Insights.
 *
 * ## Features
 *
 * - Creates an Azure AD Application and associated Service Principal
 * - Optionally generates a Service Principal password (client secret)
 * - Defines a custom Azure Role and assigns it to the Service Principal
 *
 * ## Prerequisites
 *
 * - An active Azure subscription
 * - Sufficient permissions to create Azure AD Applications, Service Principals, and Role Definitions
 *
 * ## Usage Example
 *
 * ```hcl
 * module "kompass_insights" {
 *   source = "<module-source-path-or-registry>"
 *
 *   # Optionally create a Service Principal password (client secret)
 *   # create_service_principal_password = true
 * }
 * ```
 *
 * By default, this module provisions all required Azure resources for Kompass Insights.
 *
 * ## Retrieving Service Principal Credentials
 *
 * Kompass Insights requires a Service Principal Client ID and secret for authentication.
 *
 * To retrieve the Service Principal Client ID:
 *
 * ```bash
 * terraform output -raw service_principal_client_id
 * ```
 *
 * If you have enabled password creation, retrieve the client secret with:
 *
 * ```bash
 * terraform output -raw service_principal_password
 * ```
 *
 * Alternatively, you may create a Service Principal password manually via the Azure Portal or CLI:
 *
 * ```bash
 * az ad app credential reset --id $(terraform output -raw application_client_id) --query password --output tsv
 * ```
 *
 * > **Security Notice:**
 * > Creating a Service Principal password (client secret) via Terraform will store the secret in plain text in the Terraform state file. For enhanced security, consider generating secrets externally and referencing them as needed.
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

  create_managed_identity                = var.create && var.create_managed_identity
  create_managed_identity_resource_group = local.create_managed_identity && var.create_managed_identity_resource_group
  create_service_principal               = var.create && var.create_service_principal
  create_service_principal_password      = local.create_service_principal && var.create_service_principal_password
  create_role                            = var.create && var.create_role

  # Tags used for all resources
  tags = {
    Zesty = "true"
  }
}

################################################################################
# Kompass Insights Managed Identity
################################################################################
resource "azurerm_resource_group" "this" {
  count = local.create_managed_identity_resource_group ? 1 : 0

  name     = var.managed_identity_resource_group_name
  location = var.managed_identity_resource_group_location

  tags = merge(
    local.tags,
    var.tags,
    var.managed_identity_resource_group_tags
  )
}

resource "azurerm_user_assigned_identity" "this" {
  count = local.create_managed_identity ? 1 : 0

  name = var.managed_identity_name

  location            = length(var.managed_identity_location) > 0 ? var.managed_identity_location : azurerm_resource_group.this[0].location
  resource_group_name = length(var.managed_identity_resource_group_name) > 0 ? var.managed_identity_resource_group_name : azurerm_resource_group.this[0].name

  tags = merge(
    local.tags,
    var.tags,
    var.managed_identity_tags
  )
}

resource "azurerm_role_assignment" "managed_identity" {
  count = local.create_managed_identity && local.create_role ? 1 : 0

  scope              = var.role_scope == null ? local.current_subscription_id : var.role_scope
  description        = var.role_assignment_description
  role_definition_id = azurerm_role_definition.this[0].role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.this[0].principal_id
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

resource "azurerm_role_assignment" "service_principal" {
  count = local.create_service_principal && local.create_role ? 1 : 0

  scope              = var.role_scope == null ? local.current_subscription_id : var.role_scope
  description        = var.role_assignment_description
  role_definition_id = azurerm_role_definition.this[0].role_definition_resource_id
  principal_id       = azuread_service_principal.this[0].object_id
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
