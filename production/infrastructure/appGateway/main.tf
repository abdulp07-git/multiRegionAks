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
    name = "http-settings-django"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 30
    host_name = "django.intodepth.in"
  }

  http_listener {
    name = "listener-django"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name = "http-port"
    protocol = "Http"
    host_name = "django.intodepth.in"
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  request_routing_rule {
    name = "rule-django"
    rule_type = "Basic"
    priority = 100
    http_listener_name = "listener-django"
    backend_address_pool_name = "appgw-backend-pool"
    backend_http_settings_name = "http-settings-django"
  }

}
