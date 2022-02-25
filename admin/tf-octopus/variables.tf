variable "serverURL" {
    type = string
}

variable "apiKey" {
    type = string
	sensitive = true
}

variable "student_display_name"{
    type = string
}
variable "student_email"{
    type = string
}
variable "student_username"{
    type = string
}
variable "student_password"{
    type = string
    sensitive = true
}

variable "space_name"{
    type = string
}

variable "space_description"{
    type = string
}

variable "automation_userid"{
    type = string
}

variable "azure_tenant_id"{
    type = string
}

variable "azure_subscription"{
    type = string
}

variable "azure_app_id"{
    type = string
}

variable "azure_sp_secret"{
    type = string
    sensitive = true
}

variable "variableSetName" {
    type = string
}

variable "description" {
    type = string
}

variable "slack_url" {
	type = string
	sensitive = true
}
