################################################################################
# Kompass Insights Managed Identity
################################################################################

output "managed_identity_resource_group_id" {
  description = "The resource ID of the Resource Group for the Managed Identity"
  value       = module.kompass_insights.managed_identity_resource_group_id
}

output "managed_identity_resource_group_location" {
  description = "The location of the Resource Group for the Managed Identity"
  value       = module.kompass_insights.managed_identity_resource_group_location
}

output "managed_identity_id" {
  description = "The resource ID of the Managed Identity"
  value       = module.kompass_insights.managed_identity_id
}

output "managed_identity_name" {
  description = "The name of the Managed Identity"
  value       = module.kompass_insights.managed_identity_name
}

output "managed_identity_location" {
  description = "The location of the Managed Identity"
  value       = module.kompass_insights.managed_identity_location
}

output "managed_identity_resource_group_name" {
  description = "The name of the Resource Group containing the Managed Identity"
  value       = module.kompass_insights.managed_identity_resource_group_name
}

output "managed_identity_client_id" {
  description = "The Client ID of the Managed Identity"
  value       = module.kompass_insights.managed_identity_client_id
}

output "managed_identity_principal_id" {
  description = "The Principal ID of the Managed Identity"
  value       = module.kompass_insights.managed_identity_principal_id
}

output "managed_identity_tenant_id" {
  description = "The Tenant ID of the Managed Identity"
  value       = module.kompass_insights.managed_identity_tenant_id
}

output "managed_identity_federated_credential_id" {
  description = "The resource ID of the Managed Identity Federated Credential"
  value       = module.kompass_insights.managed_identity_federated_credential_id
}

output "managed_identity_federated_credential_name" {
  description = "The name of the Managed Identity Federated Credential"
  value       = module.kompass_insights.managed_identity_federated_credential_name
}

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
