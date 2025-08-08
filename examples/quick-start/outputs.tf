################################################################################
# Kompass Insights Azure AD Service Principal
################################################################################

output "application_object_id" {
  description = "The Azure AD Application object ID"
  value       = module.kompass_insights.application_object_id
}

output "application_client_id" {
  description = "The Azure AD Application client ID/application ID"
  value       = module.kompass_insights.application_client_id
}

output "application_display_name" {
  description = "The Azure AD Application display name"
  value       = module.kompass_insights.application_display_name
}

output "application_owner_object_ids" {
  description = "The Azure AD Application object IDs of the owners"
  value       = module.kompass_insights.application_owner_object_ids
}

output "service_principal_object_id" {
  description = "The Azure AD Service Principal object ID"
  value       = module.kompass_insights.service_principal_object_id
}

output "service_principal_client_id" {
  description = "The Azure AD Service Principal client ID/application ID"
  value       = module.kompass_insights.service_principal_client_id
}

output "service_principal_display_name" {
  description = "The Azure AD Service Principal display name"
  value       = module.kompass_insights.service_principal_display_name
}

output "service_principal_owner_object_ids" {
  description = "The Azure AD Service Principal object IDs of the owners"
  value       = module.kompass_insights.service_principal_owner_object_ids
}

output "service_principal_key_id" {
  description = "The Azure AD Service Principal key ID"
  value       = module.kompass_insights.service_principal_key_id
}

output "service_principal_password" {
  description = "The Azure AD Service Principal password"
  value       = module.kompass_insights.service_principal_password
  sensitive   = true
}

################################################################################
# Kompass Insights Subscription Role
################################################################################

output "role_name" {
  description = "The Azure AD Role name"
  value       = module.kompass_insights.role_name
}

output "role_definition_id" {
  description = "The Azure AD Role ID"
  value       = module.kompass_insights.role_definition_id
}

output "role_definition_resource_id" {
  description = "The Azure AD Role resource ID"
  value       = module.kompass_insights.role_definition_resource_id
}
