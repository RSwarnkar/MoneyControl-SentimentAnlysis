
resource "azurerm_resource_group" "rg01" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    GithubRepo = "RSwarnkar/MoneyControl-SentimentAnlysis"
    CreatedBy  = "Terraform"
  }
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account

# Text Analytics - Azure AI - Language Service
resource "azurerm_cognitive_account" "textanalytics" {
  name                          = var.azure_ai_text_analytics.name
  location                      = azurerm_resource_group.rg01.location
  resource_group_name           = azurerm_resource_group.rg01.name
  kind                          = "TextAnalytics"
  sku_name                      = var.azure_ai_text_analytics.sku_name # "F0"  # Free tier; use "S0" for Standard tier
  custom_subdomain_name         = var.azure_ai_text_analytics.name
  public_network_access_enabled = true
  # identity {
  #   type = "SystemAssigned"
  # }
  tags = {
    GithubRepo = "RSwarnkar/MoneyControl-SentimentAnlysis"
    CreatedBy  = "Terraform"
  }
  depends_on = [azurerm_resource_group.rg01]
  lifecycle {
    ignore_changes = [
      network_acls
    ]
  }
}


# Azure Container Instance:
# https://learn.microsoft.com/en-us/training/modules/investigate-container-for-use-with-ai-services/3-use-ai-services-container

resource "azurerm_container_group" "aci" {

  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location

  name           = var.azure_container_instance.name
  sku            = var.azure_container_instance.sku
  dns_name_label = var.azure_container_instance.dns_name_label # must be unique globally

  os_type         = "Linux"
  ip_address_type = "Public"

  # identity {
  #   type = "SystemAssigned"
  # }

  container {
    name   = var.azure_container_instance.container_name
    image  = "mcr.microsoft.com/azure-cognitive-services/textanalytics/sentiment:latest"
    cpu    = "1"
    memory = "4"

    ports {
      port     = 5000
      protocol = "TCP"
    }

    environment_variables = {
      "Billing" = "https://${var.azure_container_instance.text_analytics_resource_name}.cognitiveservices.azure.com/"
      "Eula"    = "accept"
    }
    secure_environment_variables = {
      "ApiKey" = azurerm_cognitive_account.textanalytics.primary_access_key
    }
  }

  tags = {
    GithubRepo = "RSwarnkar/MoneyControl-SentimentAnlysis"
    CreatedBy  = "Terraform"
  }

  depends_on = [
    azurerm_cognitive_account.textanalytics,
    azurerm_resource_group.rg01
  ]
}




