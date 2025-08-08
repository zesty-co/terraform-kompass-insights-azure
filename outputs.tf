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
