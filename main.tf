resource "azurerm_resource_group" "rg-name" {
  name     = "testing_rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vn-01" {
  name                = "testing-vn-01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-name.location
  resource_group_name = azurerm_resource_group.rg-name.name
}

resource "azurerm_subnet" "subnet-01" {
  name                 = "subnet-01"
  resource_group_name  = azurerm_resource_group.rg-name.name
  virtual_network_name = azurerm_virtual_network.vn-01.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic-01" {
  name                = "nic_testing-01"
  location            = azurerm_resource_group.rg-name.location
  resource_group_name = azurerm_resource_group.rg-name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual-machine-01" {
  name                = "vn-01"
  resource_group_name = azurerm_resource_group.rg-name.name
  location            = azurerm_resource_group.rg-name.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.vmpassword.value 
  network_interface_ids = [
    azurerm_network_interface.nic-01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

