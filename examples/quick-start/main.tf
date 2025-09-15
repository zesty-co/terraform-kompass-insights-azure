data "azurerm_kubernetes_cluster" "current" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

data "azurerm_resource_group" "current" {
  name = var.cluster_resource_group_name
}

# Creates the cloud resources for Kompass Compute.
module "kompass_insights" {
  # source = "../../"
  source  = "zesty-co/insights-azure/kompass"
  version = ">= 1.0.0, < 2.0.0"

  managed_identity_location                    = data.azurerm_resource_group.current.location
  managed_identity_resource_group_name         = data.azurerm_resource_group.current.name
  managed_identity_federated_credential_issuer = data.azurerm_kubernetes_cluster.current.oidc_issuer_url
}
