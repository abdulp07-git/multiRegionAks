/*ACR in Central India*/

resource "azurerm_container_registry" "maks-acr" {
  name = var.acr-name
  resource_group_name = var.rg_names[2]
  location = var.rg_location[2]
  sku = "Basic"
  admin_enabled = false
}
