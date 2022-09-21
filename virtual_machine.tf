resource "azurerm_network_interface" "interface" {
  for_each = toset(var.vm_name)
  name                = each.value
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet._10-0-2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip[each.key].id
  }
}

#resource "azurerm_network_interface_security_group_association" "association" {
#  for_each = azurerm_network_interface.interface
#  network_interface_id      = azurerm_network_interface.interface[each.key].id
#  network_security_group_id = azurerm_network_security_group.nsg_wide_open.id
#}

resource "azurerm_linux_virtual_machine" "linux_machine" {
  for_each = toset(var.vm_name)
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.interface[each.key].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts-gen2" 
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
        environment = "tf_azure"
  }
}