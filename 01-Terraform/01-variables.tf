variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}


variable "azure_ai_text_analytics" {
  type = object({
    name     = string
    sku_name = string
  })
}

variable "azure_container_instance" {
  type = object({
    name                         = string
    dns_name_label               = string
    container_name               = string
    text_analytics_resource_name = string
    sku                          = string
  })
}

