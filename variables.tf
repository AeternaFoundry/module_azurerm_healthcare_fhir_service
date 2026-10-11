variable "healthcare_fhir_services" {
  description = <<EOT
Map of healthcare_fhir_services, attributes below
Required:
    - location
    - name
    - resource_group_name
    - workspace_id
    - authentication (block):
        - audience (required)
        - authority (required)
        - smart_proxy_enabled (optional)
Optional:
    - access_policy_object_ids
    - configuration_export_storage_account_name
    - container_registry_login_server_url
    - kind
    - tags
    - cors (block):
        - allowed_headers (required)
        - allowed_methods (required)
        - allowed_origins (required)
        - credentials_allowed (optional)
        - max_age_in_seconds (optional)
    - identity (block):
        - identity_ids (optional)
        - type (required)
    - oci_artifact (block):
        - digest (optional)
        - image_name (optional)
        - login_server (required)
EOT

  type = map(object({
    location                                  = string
    name                                      = string
    resource_group_name                       = string
    workspace_id                              = string
    access_policy_object_ids                  = optional(set(string))
    configuration_export_storage_account_name = optional(string)
    container_registry_login_server_url       = optional(set(string))
    kind                                      = optional(string)
    tags                                      = optional(map(string))
    authentication = object({
      audience            = string
      authority           = string
      smart_proxy_enabled = optional(bool)
    })
    cors = optional(object({
      allowed_headers     = set(string)
      allowed_methods     = set(string)
      allowed_origins     = set(string)
      credentials_allowed = optional(bool)
      max_age_in_seconds  = optional(number)
    }))
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }))
    oci_artifact = optional(list(object({
      digest       = optional(string)
      image_name   = optional(string)
      login_server = string
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        length(v.resource_group_name) <= 90
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) > 90]"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        !endswith(v.resource_group_name, ".")
      )
    ])
    error_message = "[from resourcegroups.ValidateName: must not end with \".\"]"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        length(v.resource_group_name) != 0
      )
    ])
    error_message = "[from resourcegroups.ValidateName: invalid when len(value) == 0]"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.access_policy_object_ids == null || (alltrue([for x in v.access_policy_object_ids : can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", x))]))
      )
    ])
    error_message = "must be a valid UUID"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        length(v.authentication.authority) > 0
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.container_registry_login_server_url == null || (alltrue([for x in v.container_registry_login_server_url : length(x) > 0]))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.oci_artifact == null || alltrue([for item in v.oci_artifact : (length(item.login_server) > 0)])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.oci_artifact == null || alltrue([for item in v.oci_artifact : (item.image_name == null || (length(item.image_name) > 0))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.oci_artifact == null || alltrue([for item in v.oci_artifact : (item.digest == null || (length(item.digest) > 0))])
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.cors == null || (alltrue([for x in v.cors.allowed_origins : length(x) > 0]))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.cors == null || (alltrue([for x in v.cors.allowed_headers : length(x) > 0]))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.cors == null || (alltrue([for x in v.cors.allowed_methods : contains(["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"], x)]))
      )
    ])
    error_message = "must be one of: DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT, PATCH"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.cors == null || (v.cors.max_age_in_seconds == null || (v.cors.max_age_in_seconds >= 0 && v.cors.max_age_in_seconds <= 2000000000))
      )
    ])
    error_message = "must be between 0 and 2000000000"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.configuration_export_storage_account_name == null || (length(v.configuration_export_storage_account_name) > 0)
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.healthcare_fhir_services : (
        v.tags == null || (length(v.tags) <= 50)
      )
    ])
    error_message = "[from tags.Validate: invalid when len(value) > 50]"
  }
  # Note: 12 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

