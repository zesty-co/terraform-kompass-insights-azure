<!-- BEGIN_TF_DOCS -->
# Zesty Kompass Insights Azure Module

This Terraform module provisions Azure Active Directory (Azure AD) Applications,
Service Principals, and custom Role Definitions required for Kompass Insights.

## Features

- Creates an Azure AD Application and associated Service Principal
- Optionally generates a Service Principal password (client secret)
- Defines a custom Azure Role and assigns it to the Service Principal

## Prerequisites

- An active Azure subscription
- Sufficient permissions to create Azure AD Applications, Service Principals, and Role Definitions

## Usage Example

```hcl
module "kompass_insights" {
  source = "<module-source-path-or-registry>"

  # Optionally create a Service Principal password (client secret)
  # create_service_principal_password = true
}
```

By default, this module provisions all required Azure resources for Kompass Insights.

## Retrieving Service Principal Credentials

Kompass Insights requires a Service Principal Client ID and secret for authentication.

To retrieve the Service Principal Client ID:

```bash
terraform output -raw service_principal_client_id
```

If you have enabled password creation, retrieve the client secret with:

```bash
terraform output -raw service_principal_password
```

Alternatively, you may create a Service Principal password manually via the Azure Portal or CLI:

```bash
az ad app credential reset --id $(terraform output -raw application_client_id) --query password --output tsv
```

> **Security Notice:**
> Creating a Service Principal password (client secret) via Terraform will store the secret in plain text in the Terraform state file. For enhanced security, consider generating secrets externally and referencing them as needed.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Create Kompass Insights resources | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Determines whether to create a role | `bool` | `true` | no |
| <a name="input_create_service_principal"></a> [create\_service\_principal](#input\_create\_service\_principal) | Determines whether to create an Azure AD Service Principal | `bool` | `true` | no |
| <a name="input_create_service_principal_password"></a> [create\_service\_principal\_password](#input\_create\_service\_principal\_password) | Determines whether to create a password for the service principal | `bool` | `false` | no |
| <a name="input_role_assignable_scopes"></a> [role\_assignable\_scopes](#input\_role\_assignable\_scopes) | A list of assignable scopes for the role. If not provided, the current subscription will be used | `list(string)` | `null` | no |
| <a name="input_role_assignment_description"></a> [role\_assignment\_description](#input\_role\_assignment\_description) | Description of the role assignment | `string` | `"Kompass Insights role assignment"` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the role | `string` | `"Kompass Insights role"` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role | `string` | `"KompassInsights"` | no |
| <a name="input_role_scope"></a> [role\_scope](#input\_role\_scope) | Scope of the role. If not provided, the current subscription will be used | `string` | `null` | no |
| <a name="input_service_principal_application_name"></a> [service\_principal\_application\_name](#input\_service\_principal\_application\_name) | The name of the service principal's application | `string` | `"kompass-insights"` | no |
| <a name="input_service_principal_owner_use_current_identity"></a> [service\_principal\_owner\_use\_current\_identity](#input\_service\_principal\_owner\_use\_current\_identity) | Determines whether to use the current identity as the service principal owner | `bool` | `true` | no |
| <a name="input_service_principal_owners"></a> [service\_principal\_owners](#input\_service\_principal\_owners) | A list of Azure AD owner IDs for the service principal | `list(string)` | `[]` | no |
| <a name="input_service_principal_password_display_name"></a> [service\_principal\_password\_display\_name](#input\_service\_principal\_password\_display\_name) | The name of the service principal's password | `string` | `"kompass-insights"` | no |
| <a name="input_service_principal_password_end_date"></a> [service\_principal\_password\_end\_date](#input\_service\_principal\_password\_end\_date) | The end date of the service principal's password | `string` | `null` | no |
| <a name="input_service_principal_password_end_date_relative"></a> [service\_principal\_password\_end\_date\_relative](#input\_service\_principal\_password\_end\_date\_relative) | The relative end date of the service principal's password | `string` | `null` | no |
| <a name="input_service_principal_password_rotate_when_changed"></a> [service\_principal\_password\_rotate\_when\_changed](#input\_service\_principal\_password\_rotate\_when\_changed) | A map of arbitrary key/value pairs that will force recreation of the password when they change | `map(any)` | `null` | no |
| <a name="input_service_principal_password_start_date"></a> [service\_principal\_password\_start\_date](#input\_service\_principal\_password\_start\_date) | The start date of the service principal's password | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_id"></a> [application\_client\_id](#output\_application\_client\_id) | The Azure AD Application client ID/application ID |
| <a name="output_application_display_name"></a> [application\_display\_name](#output\_application\_display\_name) | The Azure AD Application display name |
| <a name="output_application_object_id"></a> [application\_object\_id](#output\_application\_object\_id) | The Azure AD Application object ID |
| <a name="output_application_owner_object_ids"></a> [application\_owner\_object\_ids](#output\_application\_owner\_object\_ids) | The Azure AD Application object IDs of the owners |
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
