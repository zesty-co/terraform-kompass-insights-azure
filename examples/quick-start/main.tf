/**
 * # Quick Start Example — Kompass Insights Azure
 *
 * This example demonstrates how to use the Kompass Insights Azure module to provision the required Azure AD Application, Service Principal, and custom Role Definition for Kompass Insights.
 *
 * ## Usage
 *
 * ```hcl
 * module "kompass_insights" {
 *   source = "../../"
 *
 *   # Optionally create a Service Principal password (client secret)
 *   # create_service_principal_password = true
 * }
 * ```
 *
 * By default, this will create all necessary Azure resources.
 * To retrieve the Service Principal password (if created), run:
 *
 * ```bash
 * terraform output -raw service_principal_password
 * ```
 *
 * For more advanced configuration, see the main module documentation.
 *
 */

data "azurerm_kubernetes_cluster" "current" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

data "azurerm_resource_group" "current" {
  name = var.cluster_resource_group_name
}

# Creates the cloud resources for Kompass Compute.
module "kompass_insights" {
  # source  = "zesty-co/compute/kompass"
  # version = "~> 1.0.0"
  source = "../../"


  # create_managed_identity = false
  managed_identity_location                    = data.azurerm_resource_group.current.location
  managed_identity_resource_group_name         = data.azurerm_resource_group.current.name
  managed_identity_federated_credential_issuer = data.azurerm_kubernetes_cluster.current.oidc_issuer_url

  # Create a Service Principal password (client secret)
  create_service_principal_password = var.create_service_principal_password
}
