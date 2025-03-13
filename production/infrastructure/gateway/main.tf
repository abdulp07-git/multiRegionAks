resource "azurerm_public_ip" "appgw_pip" {
  name = "appgw_pip"
  resource_group_name = var.rg
  location = var.location
  allocation_method = "Static"
  sku = "Standard"
}


resource "azurerm_application_gateway" "app-gway" {
  name = "app-gway"
  resource_group_name = var.rg
  location = var.location
  
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
  gateway_ip_configuration {
    name = "appgw-ip-config"
    subnet_id = var.subnetid

  }

  frontend_ip_configuration {
    name = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "appgw-backend-pool"
    ip_addresses = ["10.0.1.64"]
  }

  #backend_http_settings {
    #name = "http-settings-intodepth"
    #cookie_based_affinity = "Disabled"
    #port = 80
    #protocol = "Http"
    #request_timeout = 30
    #host_name = "intodepth.com"  # 👈 Ensures correct routing
    #pick_host_name_from_backend_address = true  # 👈 Automatically picks host from ingress rules
  #}


    #backend_http_settings {
    #name = "http-settings-grafana"
    #cookie_based_affinity = "Disabled"
    #port = 80
    #protocol = "Http"
    #request_timeout = 30
    #host_name = "grafana.intodepth.com"  # 👈 Ensures correct routing
    #pick_host_name_from_backend_address = true  # 👈 Automatically picks host from ingress rules
  #}


    backend_http_settings {
    name = "http-settings-django"
    cookie_based_affinity = "Disabled"
    port = 80
    protocol = "Http"
    request_timeout = 30
    host_name = "django.intodepth.com"  # 👈 Ensures correct routing
    #pick_host_name_from_backend_address = true  # 👈 Automatically picks host from ingress rules
  }

  #http_listener {
    #name = "listener-intodepth"
    #frontend_ip_configuration_name = "appgw-frontend-ip"
    #frontend_port_name = "http-port"
    #protocol = "Http"
    #host_name = "intodepth.com"
  #}

  #http_listener {
    #name = "listener-grafana"
    #frontend_ip_configuration_name = "appgw-frontend-ip"
    #frontend_port_name = "http-port"
    #protocol = "Http"
    #host_name = "grafana.intodepth.com"
  #}

  http_listener {
    name = "listener-django"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name = "http-port"
    protocol = "Http"
    host_name = "django.intodepth.com"
  }


  frontend_port {
    name = "http-port"
    port = 80
  }

  #request_routing_rule {
    #name = "rule-intodepth"
    #rule_type = "Basic"
    #priority = 100
    #http_listener_name = "listener-intodepth"
    #backend_address_pool_name = "appgw-backend-pool"
    #backend_http_settings_name = "http-settings-intodepth"
  #}

  #request_routing_rule {
    #name = "rule-grafana"
    #rule_type = "Basic"
    #priority = 110
    #http_listener_name = "listener-grafana"
    #backend_address_pool_name = "appgw-backend-pool"
    #backend_http_settings_name = "http-settings-grafana"
  #}

  request_routing_rule {
    name = "rule-django"
    rule_type = "Basic"
    priority = 120
    http_listener_name = "listener-django"
    backend_address_pool_name = "appgw-backend-pool"
    backend_http_settings_name = "http-settings-django"
  }
}
