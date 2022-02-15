variable "student_slug"{
    type = string
}

variable "az_tenant_id"{
    type = string
}

variable "az_subscription"{
    type = string
}

variable "az_app_id"{
    type = string
}

variable "az_sp_secret"{
    type = string
    sensitive = true
}

variable "az_location"{
    type = string
}

variable "az_resource_group_name"{
    type = string
}

variable "az_app_service_plan_name"{
    type = string
}
