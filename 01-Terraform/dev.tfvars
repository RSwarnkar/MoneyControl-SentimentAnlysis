
resource_group_name = "rasw-rsg-eus-d-azureai"
location            = "East US"


# Azure AI > Foundry > Language Services > Text Analytics or aka Sentiment Analytics
azure_ai_text_analytics = {
  resource_group_name = "rasw-rsg-eus-d-azureai"
  location            = "East US"
  name                = "rasw-aai-eus-d-textanalytics"
  sku_name            = "S" # "S0"# "F0"
}

# Azure Container Instance
azure_container_instance = {
  name                         = "rasw-aci-eus-d-aci01"
  dns_name_label               = "rasw-aci01"
  container_name               = "rasw-aci01"
  text_analytics_resource_name = "rasw-aai-eus-d-textanalytics"
  sku                          = "Standard"
}
