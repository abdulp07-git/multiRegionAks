resource "azurerm_public_ip" "appgw-pip" {
  count = length(var.region)
  name = "appgw-pip-${var.region[count.index]}"
  resource_group_name = var.rg_names[count.index]
  location = var.rg_location[count.index]
  allocation_method = "Static"
  sku = "Standard"
}


resource "azurerm_application_gateway" "app-gway" {
  count = length(var.region)
  name = "app-gateway-${var.region[count.index]}"
  resource_group_name = var.rg_names[count.index]
  location = var.rg_location[count.index]
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name = "appgw-ip-config"
    subnet_id = var.subnet2_id[count.index]
  }

  frontend_ip_configuration {
    name = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw-pip[count.index].id
  }

  backend_address_pool {
    name = "appgw-backend-pool"
    ip_addresses = [ var.backend[count.index] ]
  }
  
  backend_http_settings {
    name = "http-settings-maven"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 30
    host_name = var.hostname
  }

  http_listener {
    name = "listener-maven"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name = "http-port"
    protocol = "Http"
    host_name = var.hostname
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  request_routing_rule {
    name = "rule-maven"
    rule_type = "Basic"
    priority = 100
    http_listener_name = "listener-maven"
    backend_address_pool_name = "appgw-backend-pool"
    backend_http_settings_name = "http-settings-maven"
  }

}
