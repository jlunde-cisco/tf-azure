
resource "azurerm_virtual_network" "_10" {
  name                = "virtual_network_10"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "_10-0-2" {
  name                 = "subnet_10_0_2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network._10.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  for_each = toset(var.vm_name)
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet._10-0-2.id
  network_security_group_id = azurerm_network_security_group.nsg_wide_open.id
}