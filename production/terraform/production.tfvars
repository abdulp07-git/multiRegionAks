region = [ "eastus", "ukwest", "centralindia" ]
rgname = "pro"
acr-name = "maksacr"
default_node_pool_size = "Standard_DS2_v2"
default_node_pool_count = 1
worker_node_pool_size = "Standard_A2m_v2"
worker_node_pool_count = 1
backend = [ 
        "10.0.0.63",
        "10.1.0.63",
        "10.2.0.64"
         ]
hostname = "maven.intodepth.in"
afd-domain-name = "maven.intodepth.in"
