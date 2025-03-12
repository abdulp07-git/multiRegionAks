variable "location" {
  type = string
  default = "central India"
}

variable "rgname" {
  type = string
  default = "bw89rg"
}

variable "vnetname" {
  type = string
  default = "bw89vnet"
}

variable "cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnetname" {
  type = string
  default = "subnet-aks"
}

variable "subnetiprange" {
  type = string
  default = "10.0.1.0/24"
}

variable "subnetname2" {
  type = string
  default = "subnet-gateway"
}

variable "subnetgatewayrange" {
  type = string
  default = "10.0.2.0/24"
}

variable "security-rule" {
  type = list(object({
    name = string
    priority = number
    destination_port = string
  }))

  default = [ {
    name = "allow-ssh", priority = 1000, destination_port = "22"
  },
  {
    name = "allow-http", priority = 1001, destination_port = "80"
  },
  {
    name = "allow-https", priority = 1002, destination_port = "443"
  },
  {
    name = "allow-lb", priority = 1003, destination_port = "65200-65535"
  },
  {
    name = "allow-maven", priority = 1004, destination_port = "8080"
  },
  
  {
    name = "allow-kibana", priority = 1005, destination_port = "5601"
  },
  {
    name = "allow-grafana", priority = 1006, destination_port = "3000"
  },
  {
    name = "allow-django", priority = 1007, destination_port = "8000"
  },
  {
    name = "allow-frontend", priority = 1008, destination_port = "30001"
  } ]
}


variable "ssh-key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr1wa6fD/FWd2AG9IflJXq4TbYnD0fUt629Wd2GmTmclYP1ijUT6xAhaFp2NK4h5fs96zJTD3koKI0Fxe39V+aReVy9bmS3TvYan4jlimJ6cLbhnVRTkHpI3cTEP9iXmA7jpiQnmkVtsSLiDKr2/ZXwNEEdksNJ8pVXVSLnzPs2unOaPjMVYR+nWSi8ldtNzRT8q6GrFcd/H8c+w0poDweIpzZX0kvoJk0Dlab2Nrzdl30abq/P9M5VEDR5uGKADBqj58kPBq+ymTC/PLJR2XFSIKhC5wGca7l6KiqkQyDStquae4CTRSSwvhj36s+MrZBPoDHqGDgoQ55HPhjg4AkPkmdEh9XrAL+VWkNMIPdTMaj1rbCxPeVrmBDiIfHbHMrsadlEaeVyOypP/ILz7h0iULt1fosesZyC4XjseAnB6nxRTrpCDmTUVi/E43FDaxcN+Ud+d32hkLPHHnfo5cdeFMS/f5W35/R7W8VQ9EBOjgGWLbXdIxgQ1WE48ITzIE="
}
