output "aci_fqdn" {
  value       = azurerm_container_group.aci.fqdn
  description = "FQDN of the Azure container group"
}

output "primary_apikey" {
  value       = azurerm_cognitive_account.textanalytics.primary_access_key
  description = "Sensitive: API Key 1 of the Azure AI Language Service"
  sensitive   = true
}

# output "secondary_apikey" {
#   value       = azurerm_cognitive_account.textanalytics.secondary_access_key
#   description = "Sensitive: API Key 2 of the Azure AI Language Service"
#   sensitive = true
# }