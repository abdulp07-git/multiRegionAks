resource "azurerm_frontdoor" "afd" {
  name                = "maven-intodepth-frontend"
  resource_group_name = var.afd-rg

  routing_rule {
    name               = "geo-routing"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["afd-frontend", "afd-default"]   # ✅ Fixed Reference

    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "afd-backend-pool"  # ✅ Fixed Reference
    }
  }

  backend_pool_load_balancing {
    name = "load-balancing-settings"
  }

  backend_pool_health_probe {
    name                = "health-probe-settings"
    path                = "/"  
    protocol            = "Http"
    interval_in_seconds = 30
  }

  backend_pool {
    name = "afd-backend-pool"

    backend {
      host_header = var.afd-domain-name  
      address     = var.gateway-ips[0]  
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }


    backend {
      host_header = var.afd-domain-name
      address     = var.gateway-ips[1]  
      http_port   = 80
      https_port  = 443
      priority    = 2
      weight      = 50
    }


    backend {
      host_header = var.afd-domain-name
      address     = var.gateway-ips[2]  
      http_port   = 80
      https_port  = 443
      priority    = 3
      weight      = 50
    }

    load_balancing_name = "load-balancing-settings"
    health_probe_name   = "health-probe-settings"
  }



  frontend_endpoint {
    name      = "afd-default"
    host_name = "maven-intodepth-frontend.azurefd.net"
  }
  
  frontend_endpoint {
    name      = "afd-frontend"
    host_name = var.afd-domain-name
  }
}
