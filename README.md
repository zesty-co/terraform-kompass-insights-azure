# Zesty Kompass Insights Azure Module

This module provisions the Azure prerequisites for Kompass Insights on AKS.

It creates a Managed Identity (with a federated credential for AKS Workload Identity),
and a custom Role Definition with optional role assignments. Optionally, it can
create an Azure AD Application + Service Principal (with an optional client secret).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation instructions](#installation-instructions)
- [Deployed Resources](#deployed-resources)
- [Advanced Usage](#advanced-usage)
- [API Reference](#requirements)

## Prerequisites

- Terraform 1.0+
- Azure subscription with permissions to manage identities and roles
- AKS cluster (for Workload Identity OIDC issuer)
- Azure CLI or service principal credentials for authentication

## Quick Start

There are two typical ways to use this module:

1. Using the example in `examples/quick-start/`.
2. Using the [instructions below](#installation-instructions).

## Installation instructions

The simplest way to install involves creating a Terraform configuration with the following components:

1. A provider section that helps with the following things:
   1. Azure RM provider - Get cluster information.
   2. Azure AD provider - Create the Azure AD application and service principal.
2. Invocation of the kompass-insights module that installs all required Azure resources.

Below is a sample configuration for the necessary providers that help perform the later steps.

If your setup is different, you will need to adjust the configuration accordingly.

```hcl
provider "azuread" {}

provider "azurerm" {
  # Provide subscription_id or set the environment variable ARM_SUBSCRIPTION_ID
  # subscription_id = ""
  features {}
}
```

Below is a configuration that deploys the Kompass Insights module.

```hcl
data "azurerm_kubernetes_cluster" "current" {
  name                = var.cluster_name
  resource_group_name = var.cluster_resource_group_name
}

data "azurerm_resource_group" "current" {
  name = var.cluster_resource_group_name
}

module "kompass_insights" {
  source  = "zesty-co/insights-azure/kompass"
  version = ">= 1.0.0, < 2.0.0"

  managed_identity_location                    = data.azurerm_resource_group.current.location
  managed_identity_resource_group_name         = data.azurerm_resource_group.current.name
  managed_identity_federated_credential_issuer = data.azurerm_kubernetes_cluster.current.oidc_issuer_url
}
```

## Deployed Resources

- User Assigned Managed Identity (`azurerm_user_assigned_identity`) with tags
- Federated Identity Credential (`azurerm_federated_identity_credential`) bound to the Managed Identity
- Optional Resource Group (`azurerm_resource_group`) for the Managed Identity
- Custom Role Definition (`azurerm_role_definition`) with minimal read permissions for Kompass Insights
- Role Assignments (`azurerm_role_assignment`) for either the Managed Identity or Service Principal
- Optional Azure AD resources when enabled:
  - Application (`azuread_application`)
  - Service Principal (`azuread_service_principal`)
  - Application Password (`azuread_application_password`)

## Advanced Usage

### Use an existing Resource Group

Set `create_managed_identity_resource_group = false` and provide
`managed_identity_resource_group_name` and `managed_identity_location`.

### Control role creation and assignment

- To use an existing role, set `create_role = false` and pass either
  `role_definition_id` or `role_name`.

### Use Service Principal instead of Managed Identity

Enable the Service Principal path by setting `create_service_principal = true`.
Optionally create a client secret with `create_service_principal_password = true`.

Security note: Creating secrets with Terraform stores them in state in plaintext.
Consider creating secrets externally and passing them securely instead.

### Retrieving Service Principal credentials (when enabled)

```bash
terraform output -raw service_principal_client_id
terraform output -raw service_principal_password
```

<!-- BEGIN_TF_DOCS -->
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
| [azurerm_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.service_principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Create Kompass Insights resources | `bool` | `true` | no |
| <a name="input_create_managed_identity"></a> [create\_managed\_identity](#input\_create\_managed\_identity) | Determines whether to create a Managed Identity | `bool` | `true` | no |
| <a name="input_create_managed_identity_federated_credential"></a> [create\_managed\_identity\_federated\_credential](#input\_create\_managed\_identity\_federated\_credential) | Determines whether to create a federated credential for the Managed Identity | `bool` | `true` | no |
| <a name="input_create_managed_identity_resource_group"></a> [create\_managed\_identity\_resource\_group](#input\_create\_managed\_identity\_resource\_group) | Determines whether to create a Resource Group for the Managed Identity | `bool` | `false` | no |
| <a name="input_create_managed_identity_role_assignment"></a> [create\_managed\_identity\_role\_assignment](#input\_create\_managed\_identity\_role\_assignment) | Determines whether to create a role assignment for the Managed Identity | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Determines whether to create a role | `bool` | `true` | no |
| <a name="input_create_service_principal"></a> [create\_service\_principal](#input\_create\_service\_principal) | Determines whether to create an Azure AD Service Principal | `bool` | `false` | no |
| <a name="input_create_service_principal_password"></a> [create\_service\_principal\_password](#input\_create\_service\_principal\_password) | Determines whether to create a password for the service principal | `bool` | `false` | no |
| <a name="input_create_service_principal_role_assignment"></a> [create\_service\_principal\_role\_assignment](#input\_create\_service\_principal\_role\_assignment) | Determines whether to create a role assignment for the Service Principal | `bool` | `true` | no |
| <a name="input_kompass_insights_namespace"></a> [kompass\_insights\_namespace](#input\_kompass\_insights\_namespace) | The name of the Kompass Insights namespace | `string` | `"zesty-system"` | no |
| <a name="input_kompass_insights_service_account_name"></a> [kompass\_insights\_service\_account\_name](#input\_kompass\_insights\_service\_account\_name) | The name of the Kompass Insights service account | `string` | `"kompass-insights-sa"` | no |
| <a name="input_managed_identity_federated_credential_issuer"></a> [managed\_identity\_federated\_credential\_issuer](#input\_managed\_identity\_federated\_credential\_issuer) | The issuer of the federated credential for the Managed Identity | `string` | `""` | no |
| <a name="input_managed_identity_federated_credential_name"></a> [managed\_identity\_federated\_credential\_name](#input\_managed\_identity\_federated\_credential\_name) | The name of the federated credential for the Managed Identity | `string` | `"kompass-insights"` | no |
| <a name="input_managed_identity_location"></a> [managed\_identity\_location](#input\_managed\_identity\_location) | The location of the Managed Identity. If not provided, the location of the Resource Group for the Managed Identity will be used. | `string` | `""` | no |
| <a name="input_managed_identity_name"></a> [managed\_identity\_name](#input\_managed\_identity\_name) | The name of the Managed Identity | `string` | `"kompass-insights"` | no |
| <a name="input_managed_identity_resource_group_location"></a> [managed\_identity\_resource\_group\_location](#input\_managed\_identity\_resource\_group\_location) | The location of the Resource Group for the Managed Identity | `string` | `""` | no |
| <a name="input_managed_identity_resource_group_name"></a> [managed\_identity\_resource\_group\_name](#input\_managed\_identity\_resource\_group\_name) | The name of the Resource Group for the Managed Identity | `string` | `"kompass-insights"` | no |
| <a name="input_managed_identity_resource_group_tags"></a> [managed\_identity\_resource\_group\_tags](#input\_managed\_identity\_resource\_group\_tags) | A map of tags to add to the Resource Group for the Managed Identity | `map(string)` | `{}` | no |
| <a name="input_managed_identity_tags"></a> [managed\_identity\_tags](#input\_managed\_identity\_tags) | A map of tags to add to the Managed Identity | `map(string)` | `{}` | no |
| <a name="input_role_assignable_scopes"></a> [role\_assignable\_scopes](#input\_role\_assignable\_scopes) | A list of assignable scopes for the role. If not provided, the current subscription will be used | `list(string)` | `null` | no |
| <a name="input_role_assignment_description"></a> [role\_assignment\_description](#input\_role\_assignment\_description) | Description of the role assignment | `string` | `"Kompass Insights role assignment"` | no |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | ID of the role definition | `string` | `null` | no |
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