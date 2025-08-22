################################################################################
# Kompass Insights Managed Identity
################################################################################

output "managed_identity_resource_group_id" {
  description = "The resource ID of the Resource Group for the Managed Identity"
  value       = try(azurerm_resource_group.this[0].id, null)
}

output "managed_identity_resource_group_location" {
  description = "The location of the Resource Group for the Managed Identity"
  value       = try(azurerm_resource_group.this[0].location, null)
}

output "managed_identity_id" {
  description = "The resource ID of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].id, null)
}

output "managed_identity_name" {
  description = "The name of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].name, null)
}

output "managed_identity_location" {
  description = "The location of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].location, null)
}

output "managed_identity_resource_group_name" {
  description = "The name of the Resource Group containing the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].resource_group_name, null)
}

output "managed_identity_client_id" {
  description = "The Client ID of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].client_id, null)
}

output "managed_identity_principal_id" {
  description = "The Principal ID of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].principal_id, null)
}

output "managed_identity_tenant_id" {
  description = "The Tenant ID of the Managed Identity"
  value       = try(azurerm_user_assigned_identity.this[0].tenant_id, null)
}

output "managed_identity_federated_credential_id" {
  description = "The resource ID of the Managed Identity Federated Credential"
  value       = try(azurerm_federated_identity_credential.this[0].id, null)
}

output "managed_identity_federated_credential_name" {
  description = "The name of the Managed Identity Federated Credential"
  value       = try(azurerm_federated_identity_credential.this[0].name, null)
}

################################################################################
# Kompass Insights Azure AD Service Principal
################################################################################

output "application_object_id" {
  description = "The Azure AD Application object ID"
  value       = try(azuread_application.this[0].object_id, null)
}

output "application_client_id" {
  description = "The Azure AD Application client ID/application ID"
  value       = try(azuread_application.this[0].client_id, null)
}

output "application_display_name" {
  description = "The Azure AD Application display name"
  value       = try(azuread_application.this[0].display_name, null)
}

output "application_owner_object_ids" {
  description = "The Azure AD Application object IDs of the owners"
  value       = try(azuread_application.this[0].owners, null)
}

output "service_principal_object_id" {
  description = "The Azure AD Service Principal object ID"
  value       = try(azuread_service_principal.this[0].object_id, null)
}

output "service_principal_client_id" {
  description = "The Azure AD Service Principal client ID/application ID"
  value       = try(azuread_service_principal.this[0].client_id, null)
}

output "service_principal_display_name" {
  description = "The Azure AD Service Principal display name"
  value       = try(azuread_service_principal.this[0].display_name, null)
}

output "service_principal_owner_object_ids" {
  description = "The Azure AD Service Principal object IDs of the owners"
  value       = try(azuread_service_principal.this[0].owners, null)
}

output "service_principal_key_id" {
  description = "The Azure AD Service Principal key ID"
  value       = try(azuread_application_password.this[0].key_id, null)
}

output "service_principal_password" {
  description = "The Azure AD Service Principal password"
  value       = try(azuread_application_password.this[0].value, null)
  sensitive   = true
}

################################################################################
# Kompass Insights Subscription Role
################################################################################

output "role_name" {
  description = "The Azure AD Role name"
  value       = try(azurerm_role_definition.this[0].name, null)
}

output "role_definition_id" {
  description = "The Azure AD Role ID"
  value       = try(azurerm_role_definition.this[0].role_definition_id, null)
}

output "role_definition_resource_id" {
  description = "The Azure AD Role resource ID"
  value       = try(azurerm_role_definition.this[0].role_definition_resource_id, null)
}
