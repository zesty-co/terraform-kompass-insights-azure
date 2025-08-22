/**
 * # Zesty Kompass Insights Azure Module
 *
 * This module provisions the Azure prerequisites for Kompass Insights on AKS.
 *
 * It creates a Managed Identity (with a federated credential for AKS Workload Identity),
 * and a custom Role Definition with optional role assignments. Optionally, it can
 * create an Azure AD Application + Service Principal (with an optional client secret).
 *
 * ## Table of Contents
 *
 * - [Prerequisites](#prerequisites)
 * - [Quick Start](#quick-start)
 * - [Installation instructions](#installation-instructions)
 * - [Deployed Resources](#deployed-resources)
 * - [Advanced Usage](#advanced-usage)
 * - [API Reference](#requirements)
 *
 * ## Prerequisites
 *
 * - Terraform 1.0+
 * - Azure subscription with permissions to manage identities and roles
 * - AKS cluster (for Workload Identity OIDC issuer)
 * - Azure CLI or service principal credentials for authentication
 *
 * ## Quick Start
 *
 * There are two typical ways to use this module:
 *
 * 1. Using the example in `examples/quick-start/`.
 * 2. Using the [instructions below](#installation-instructions).
 *
 * ## Installation instructions
 *
 * The simplest way to install involves creating a Terraform configuration with the following components:
 *
 * 1. A provider section that helps with the following things:
 *    1. Azure RM provider - Get cluster information.
 *    2. Azure AD provider - Create the Azure AD application and service principal.
 * 2. Invocation of the kompass-insights module that installs all required Azure resources.
 *
 * Below is a sample configuration for the necessary providers that help perform the later steps.
 *
 * If your setup is different, you will need to adjust the configuration accordingly.
 *
 * ```hcl
 * provider "azuread" {}
 *
 * provider "azurerm" {
 *   # Provide subscription_id or set the environment variable ARM_SUBSCRIPTION_ID
 *   # subscription_id = ""
 *   features {}
 * }
 * ```
 *
 * Below is a configuration that deploys the Kompass Insights module.
 *
 * ```hcl
 * data "azurerm_kubernetes_cluster" "current" {
 *   name                = var.cluster_name
 *   resource_group_name = var.cluster_resource_group_name
 * }
 *
 * data "azurerm_resource_group" "current" {
 *   name = var.cluster_resource_group_name
 * }
 *
 * module "kompass_insights" {
 *   source = "<module-source-path-or-registry>"
 *
 *   managed_identity_location                    = data.azurerm_resource_group.current.location
 *   managed_identity_resource_group_name         = data.azurerm_resource_group.current.name
 *   managed_identity_federated_credential_issuer = data.azurerm_kubernetes_cluster.current.oidc_issuer_url
 * }
 * ```
 *
 * ## Deployed Resources
 *
 * - User Assigned Managed Identity (`azurerm_user_assigned_identity`) with tags
 * - Federated Identity Credential (`azurerm_federated_identity_credential`) bound to the Managed Identity
 * - Optional Resource Group (`azurerm_resource_group`) for the Managed Identity
 * - Custom Role Definition (`azurerm_role_definition`) with minimal read permissions for Kompass Insights
 * - Role Assignments (`azurerm_role_assignment`) for either the Managed Identity or Service Principal
 * - Optional Azure AD resources when enabled:
 *   - Application (`azuread_application`)
 *   - Service Principal (`azuread_service_principal`)
 *   - Application Password (`azuread_application_password`)
 *
 * ## Advanced Usage
 *
 * ### Use an existing Resource Group
 *
 * Set `create_managed_identity_resource_group = false` and provide
 * `managed_identity_resource_group_name` and `managed_identity_location`.
 *
 * ### Control role creation and assignment
 *
 * - To use an existing role, set `create_role = false` and pass either
 *   `role_definition_id` or `role_name`.
 *
 * ### Use Service Principal instead of Managed Identity
 *
 * Enable the Service Principal path by setting `create_service_principal = true`.
 * Optionally create a client secret with `create_service_principal_password = true`.
 *
 * Security note: Creating secrets with Terraform stores them in state in plaintext.
 * Consider creating secrets externally and passing them securely instead.
 *
 * ### Retrieving Service Principal credentials (when enabled)
 *
 * ```bash
 * terraform output -raw service_principal_client_id
 * terraform output -raw service_principal_password
 * ```
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

  create_managed_identity                      = var.create && var.create_managed_identity
  create_managed_identity_resource_group       = local.create_managed_identity && var.create_managed_identity_resource_group
  create_managed_identity_federated_credential = local.create_managed_identity && var.create_managed_identity_federated_credential
  create_managed_identity_role_assignment      = local.create_managed_identity && var.create_managed_identity_role_assignment
  create_service_principal                     = var.create && var.create_service_principal
  create_service_principal_password            = local.create_service_principal && var.create_service_principal_password
  create_service_principal_role_assignment     = local.create_service_principal && var.create_service_principal_role_assignment
  create_role                                  = var.create && var.create_role

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

resource "azurerm_federated_identity_credential" "this" {
  count = local.create_managed_identity_federated_credential ? 1 : 0

  name                = var.managed_identity_federated_credential_name
  parent_id           = azurerm_user_assigned_identity.this[0].id
  resource_group_name = azurerm_user_assigned_identity.this[0].resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.managed_identity_federated_credential_issuer
  subject             = "system:serviceaccount:${var.kompass_insights_namespace}:${var.kompass_insights_service_account_name}"
}

resource "azurerm_role_assignment" "managed_identity" {
  count = local.create_managed_identity_role_assignment ? 1 : 0

  scope                = var.role_scope == null ? local.current_subscription_id : var.role_scope
  description          = var.role_assignment_description
  role_definition_id   = local.create_role ? azurerm_role_definition.this[0].role_definition_resource_id : var.role_definition_id
  role_definition_name = local.create_role ? null : ((var.role_definition_id == null || length(var.role_definition_id) == 0) ? var.role_name : null)
  principal_id         = azurerm_user_assigned_identity.this[0].principal_id
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
  count = local.create_service_principal_role_assignment ? 1 : 0

  scope                = var.role_scope == null ? local.current_subscription_id : var.role_scope
  description          = var.role_assignment_description
  role_definition_id   = local.create_role ? azurerm_role_definition.this[0].role_definition_resource_id : var.role_definition_id
  role_definition_name = local.create_role ? null : ((var.role_definition_id == null || length(var.role_definition_id) == 0) ? var.role_name : null)
  principal_id         = azuread_service_principal.this[0].object_id
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
