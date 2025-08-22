/**
 * # Quick Start
 *
 * This example shows how to install Kompass Insights module with the most basic setup.
 * It deploys Kompass Insights, which creates the cloud resources for Kompass Insights.
 *
 *
 * Before applying the module, ensure that the providers target the correct Azure subscription.
 * You need to ensure the following:
 *
 * 1. The Azure RM provider is configured to target the correct Azure subscription.
 *    Azure subscription ID have to configured through the `ARM_SUBSCRIPTION_ID` environment variable or in the provider block.
 *
 * 2. The name of the AKS cluster and AKS's resource group name are provided in the `cluster_name`
 *    and `cluster_resource_group_name` variable through a tfvars or env var.
 *    See [variables.tf](./variables.tf) for more details.
 *
 * The module works in the following order:
 *
 * 1. Scrapes the AKS cluster for information.
 * 2. Creates the cloud resources for Kompass Insights.
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

  managed_identity_location                    = data.azurerm_resource_group.current.location
  managed_identity_resource_group_name         = data.azurerm_resource_group.current.name
  managed_identity_federated_credential_issuer = data.azurerm_kubernetes_cluster.current.oidc_issuer_url
}
