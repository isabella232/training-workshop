variable "serverURL" {
    type = string
}

variable "apiKey" {
    type = string
	sensitive = true
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

variable "space" {
    type = string
}

variable "variableSetName" {
    type = string
}

variable "description" {
    type = string
}

variable "slack_url" {
	type = string
}

variable "slack_key" {
	type = string
	sensitive = true
}
