<!-- BEGIN_TF_DOCS -->
# Quick Start Example — Kompass Insights Azure

This example demonstrates how to use the Kompass Insights Azure module to provision the required Azure AD Application, Service Principal, and custom Role Definition for Kompass Insights.

## Usage

```hcl
module "kompass_insights" {
  source = "../../"

  # Optionally create a Service Principal password (client secret)
  # create_service_principal_password = true
}
```

By default, this will create all necessary Azure resources.
To retrieve the Service Principal password (if created), run:

```bash
terraform output -raw service_principal_password
```

For more advanced configuration, see the main module documentation.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kompass_insights"></a> [kompass\_insights](#module\_kompass\_insights) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_resource_group.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_resource_group_name"></a> [cluster\_resource\_group\_name](#input\_cluster\_resource\_group\_name) | The name of the Resource Group for the Kubernetes cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_id"></a> [application\_client\_id](#output\_application\_client\_id) | The Azure AD Application client ID/application ID |
| <a name="output_application_display_name"></a> [application\_display\_name](#output\_application\_display\_name) | The Azure AD Application display name |
| <a name="output_application_object_id"></a> [application\_object\_id](#output\_application\_object\_id) | The Azure AD Application object ID |
| <a name="output_application_owner_object_ids"></a> [application\_owner\_object\_ids](#output\_application\_owner\_object\_ids) | The Azure AD Application object IDs of the owners |
| <a name="output_managed_identity_client_id"></a> [managed\_identity\_client\_id](#output\_managed\_identity\_client\_id) | The Client ID of the Managed Identity |
| <a name="output_managed_identity_federated_credential_id"></a> [managed\_identity\_federated\_credential\_id](#output\_managed\_identity\_federated\_credential\_id) | The resource ID of the Managed Identity Federated Credential |
| <a name="output_managed_identity_federated_credential_name"></a> [managed\_identity\_federated\_credential\_name](#output\_managed\_identity\_federated\_credential\_name) | The name of the Managed Identity Federated Credential |
| <a name="output_managed_identity_id"></a> [managed\_identity\_id](#output\_managed\_identity\_id) | The resource ID of the Managed Identity |
| <a name="output_managed_identity_location"></a> [managed\_identity\_location](#output\_managed\_identity\_location) | The location of the Managed Identity |
| <a name="output_managed_identity_name"></a> [managed\_identity\_name](#output\_managed\_identity\_name) | The name of the Managed Identity |
| <a name="output_managed_identity_principal_id"></a> [managed\_identity\_principal\_id](#output\_managed\_identity\_principal\_id) | The Principal ID of the Managed Identity |
| <a name="output_managed_identity_resource_group_id"></a> [managed\_identity\_resource\_group\_id](#output\_managed\_identity\_resource\_group\_id) | The resource ID of the Resource Group for the Managed Identity |
| <a name="output_managed_identity_resource_group_location"></a> [managed\_identity\_resource\_group\_location](#output\_managed\_identity\_resource\_group\_location) | The location of the Resource Group for the Managed Identity |
| <a name="output_managed_identity_resource_group_name"></a> [managed\_identity\_resource\_group\_name](#output\_managed\_identity\_resource\_group\_name) | The name of the Resource Group containing the Managed Identity |
| <a name="output_managed_identity_tenant_id"></a> [managed\_identity\_tenant\_id](#output\_managed\_identity\_tenant\_id) | The Tenant ID of the Managed Identity |
| <a name="output_role_definition_id"></a> [role\_definition\_id](#output\_role\_definition\_id) | The Azure AD Role ID |
| <a name="output_role_definition_resource_id"></a> [role\_definition\_resource\_id](#output\_role\_definition\_resource\_id) | The Azure AD Role resource ID |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The Azure AD Role name |
| <a name="output_service_principal_client_id"></a> [service\_principal\_client\_id](#output\_service\_principal\_client\_id) | The Azure AD Service Principal client ID/application ID |
| <a name="output_service_principal_display_name"></a> [service\_principal\_display\_name](#output\_service\_principal\_display\_name) | The Azure AD Service Principal display name |
| <a name="output_service_principal_key_id"></a> [service\_principal\_key\_id](#output\_service\_principal\_key\_id) | The Azure AD Service Principal key ID |
| <a name="output_service_principal_object_id"></a> [service\_principal\_object\_id](#output\_service\_principal\_object\_id) | The Azure AD Service Principal object ID |
| <a name="output_service_principal_owner_object_ids"></a> [service\_principal\_owner\_object\_ids](#output\_service\_principal\_owner\_object\_ids) | The Azure AD Service Principal object IDs of the owners |
| <a name="output_service_principal_password"></a> [service\_principal\_password](#output\_service\_principal\_password) | The Azure AD Service Principal password |
<!-- END_TF_DOCS -->