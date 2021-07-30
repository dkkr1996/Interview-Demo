variable "server_name" {
  type = string
}

variable "server_location" {
  type = string
}

variable "resource_prefix" {
   type = string
}

variable "server_address_range" {
   type = string
}

variable "subnet_address_cidr" {
  type = list(string)
}