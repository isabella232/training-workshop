variable "serverURL" {
    type = string
}

variable "apiKey" {
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
