resource "azurerm_healthcare_fhir_service" "healthcare_fhir_services" {
  for_each = var.healthcare_fhir_services

  location                                  = each.value.location
  name                                      = each.value.name
  resource_group_name                       = each.value.resource_group_name
  workspace_id                              = each.value.workspace_id
  access_policy_object_ids                  = each.value.access_policy_object_ids
  configuration_export_storage_account_name = each.value.configuration_export_storage_account_name
  container_registry_login_server_url       = each.value.container_registry_login_server_url
  kind                                      = each.value.kind
  tags                                      = each.value.tags

  authentication {
    audience            = each.value.authentication.audience
    authority           = each.value.authentication.authority
    smart_proxy_enabled = each.value.authentication.smart_proxy_enabled
  }

  dynamic "cors" {
    for_each = each.value.cors != null ? [each.value.cors] : []
    content {
      allowed_headers     = cors.value.allowed_headers
      allowed_methods     = cors.value.allowed_methods
      allowed_origins     = cors.value.allowed_origins
      credentials_allowed = cors.value.credentials_allowed
      max_age_in_seconds  = cors.value.max_age_in_seconds
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      identity_ids = identity.value.identity_ids
      type         = identity.value.type
    }
  }

  dynamic "oci_artifact" {
    for_each = each.value.oci_artifact != null ? each.value.oci_artifact : []
    content {
      digest       = oci_artifact.value.digest
      image_name   = oci_artifact.value.image_name
      login_server = oci_artifact.value.login_server
    }
  }
}

