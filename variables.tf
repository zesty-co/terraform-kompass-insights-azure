variable "create" {
  description = "Create Kompass Insights resources"
  type        = bool
  default     = true
  nullable    = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
  nullable    = true
}

################################################################################
# Kompass Insights Azure AD Service Principal
################################################################################

variable "create_service_principal" {
  description = "Determines whether to create an Azure AD Service Principal"
  type        = bool
  default     = true
  nullable    = false
}

variable "service_principal_application_name" {
  description = "The name of the service principal's application"
  type        = string
  default     = "kompass-insights"
  nullable    = false
}

variable "service_principal_owner_use_current_identity" {
  description = "Determines whether to use the current identity as the service principal owner"
  type        = bool
  default     = true
  nullable    = false
}

variable "service_principal_owners" {
  description = "A list of Azure AD owner IDs for the service principal"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "create_service_principal_password" {
  description = "Determines whether to create a password for the service principal"
  type        = bool
  default     = false
  nullable    = false
}

variable "service_principal_password_display_name" {
  description = "The name of the service principal's password"
  type        = string
  default     = "kompass-insights"
  nullable    = false
}

variable "service_principal_password_start_date" {
  description = "The start date of the service principal's password"
  type        = string
  default     = null
  nullable    = true
}

variable "service_principal_password_end_date" {
  description = "The end date of the service principal's password"
  type        = string
  default     = null
  nullable    = true
}

variable "service_principal_password_end_date_relative" {
  description = "The relative end date of the service principal's password"
  type        = string
  default     = null
  nullable    = true
}

variable "service_principal_password_rotate_when_changed" {
  description = "A map of arbitrary key/value pairs that will force recreation of the password when they change"
  type        = map(any)
  default     = null
  nullable    = true
}

################################################################################
# Kompass Insights Subscription Role
################################################################################

variable "create_role" {
  description = "Determines whether to create a role"
  type        = bool
  default     = true
  nullable    = false
}

variable "role_name" {
  description = "Name of the role"
  type        = string
  default     = "KompassInsights"
  nullable    = false
}

variable "role_description" {
  description = "Description of the role"
  type        = string
  default     = "Kompass Insights role"
  nullable    = false
}

variable "role_scope" {
  description = "Scope of the role. If not provided, the current subscription will be used"
  type        = string
  default     = null
  nullable    = true
}

variable "role_assignable_scopes" {
  description = "A list of assignable scopes for the role. If not provided, the current subscription will be used"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "role_assignment_description" {
  description = "Description of the role assignment"
  type        = string
  default     = "Kompass Insights role assignment"
  nullable    = false
}
