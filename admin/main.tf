terraform {
  required_providers {
    octopusdeploy = {
      source  = "OctopusDeployLabs/octopusdeploy"
    }
  }
}

provider "octopusdeploy" {
  address  = var.serverURL
  api_key   = var.apiKey
  space_id = var.space
}

resource "octopusdeploy_library_variable_set" "student_var_set" {
  name        = var.variableSetName
  description = var.description
}

resource "octopusdeploy_variable" "var_slack_url" {
  name        = "slack-url"
  type        = "String"
  value       = var.slack_url
  owner_id    = octopusdeploy_library_variable_set.student_var_set.id
}

resource "octopusdeploy_variable" "var_slack_key" {
  name        = "slack-key"
  type        = "Sensitive"
  is_sensitive = true
  sensitive_value = var.slack_key
  owner_id    = octopusdeploy_library_variable_set.student_var_set.id
}
