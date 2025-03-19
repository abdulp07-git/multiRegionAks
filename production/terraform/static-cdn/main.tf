# 1. Create Storage Account

resource "azurerm_storage_account" "maksstaticfiles" {
  name = "maksstaticfiles"
  resource_group_name = var.rg_names[2]
  location = var.rg_location[2]
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}


# 2. Create Storage Container

resource "azurerm_storage_container" "images" {
  name = "images"
  storage_account_id = azurerm_storage_account.maksstaticfiles.id
  container_access_type = "blob"
}

# 3. Create CDN Profile

resource "azurerm_cdn_profile" "cdnprofile" {
    name = "cdnprofile"
    resource_group_name = var.rg_names[2]
    location = var.rg_location[2]
    sku = "Standard_Microsoft"
}

# 4. Create CDN Endpoint

resource "azurerm_cdn_endpoint" "makscdntoi" {
  name = "makscdntoi"
  profile_name = azurerm_cdn_profile.cdnprofile.name
  resource_group_name = var.rg_names[2]
  location = var.rg_location[2]
  origin {
    name = azurerm_storage_account.maksstaticfiles.name
    host_name = "${azurerm_storage_account.maksstaticfiles.name}.blob.core.windows.net"
    
  }
  origin_path = "/images"
  is_http_allowed  = true
  is_https_allowed = true
}
