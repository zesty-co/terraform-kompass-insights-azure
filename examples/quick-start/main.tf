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

# Creates the cloud resources for Kompass Compute.
module "kompass_insights" {
  # source  = "zesty-co/compute/kompass"
  # version = "~> 1.0.0"
  source = "../../"

  # Create a Service Principal password (client secret)
  create_service_principal_password = var.create_service_principal_password



  # create_managed_identity = false
  managed_identity_location = "northeurope"
  managed_identity_resource_group_name = "aks"
  create_managed_identity_resource_group = false
  # managed_identity_resource_group_location = "westeurope"
}
