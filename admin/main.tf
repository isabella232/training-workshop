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
}

resource "octopusdeploy_user" "new_student" {
  display_name  = var.student_display_name
  email_address = var.student_email
  is_active     = true
  is_service    = false
  password      = var.student_password
  username      = var.student_username
}

resource "octopusdeploy_space" "student_space" {
  name                        = var.space_name
  description                 = var.space_description
  is_default                  = false
  is_task_queue_stopped       = false
  space_managers_team_members = [octopusdeploy_user.new_student.id, var.automation_userid]
  space_managers_teams        = ["Teams-1"]
}

provider "octopusdeploy" {
  alias = "space_student"
  address = var.serverURL
  api_key = var.apiKey
  space_id = octopusdeploy_space.student_space.id
}

resource "octopusdeploy_azure_service_principal" "workshop_principle" {
  provider = octopusdeploy.space_student
  application_id  = var.azure_app_id
  name            = "Workshop Azure Account"
  password        = var.azure_sp_secret
  subscription_id = var.azure_subscription
  tenant_id       = var.azure_tenant_id
}

resource "octopusdeploy_library_variable_set" "student_var_set" {
  provider = octopusdeploy.space_student
  name        = var.variableSetName
  description = var.description
}

resource "octopusdeploy_variable" "var_slack_url" {
  provider = octopusdeploy.space_student
  name        = "slack-url"
  type        = "String"
  value       = var.slack_url
  owner_id    = octopusdeploy_library_variable_set.student_var_set.id
}

resource "octopusdeploy_variable" "var_slack_key" {
  provider = octopusdeploy.space_student
  name        = "slack-key"
  type        = "Sensitive"
  is_sensitive = true
  sensitive_value = var.slack_key
  owner_id    = octopusdeploy_library_variable_set.student_var_set.id
}
