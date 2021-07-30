terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "Interview" {
  name     = "var.server_name"
  location = "var.server_location"
}

resource "azurerm_virtual_network" "Interview" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = [var.server_address_range]
  location            = var.server_location
  resource_group_name = azurerm_resource_group.Interview.name


}

resource "azurerm_subnet" "Interview" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Interview.name
  virtual_network_name = azurerm_virtual_network.Interview.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "Interview" {
  name                = "ubuntu-nic"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.Interview.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Interview.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Interview.id
  }
}

resource "azurerm_linux_virtual_machine" "Interview" {
  name                = "ubuntu-machine"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.Interview.name
  size                = "Standard_ds1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.Interview.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19.04"
    version   = "latest"
  }

}

resource "azurerm_public_ip" "Interview" {
  name                = "ubuntu0001publicip1"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.Interview.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "Interview" {
  name                = "ubuntu-security-group1"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.Interview.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_interface_security_group_association" "Interview" {
  network_interface_id      = azurerm_network_interface.Interview.id
  network_security_group_id = azurerm_network_security_group.Interview.id
}
