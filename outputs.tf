output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "private_ips" {
  value = { for vm in var.vm_name : vm => azurerm_linux_virtual_machine.linux_machine[vm].private_ip_address }
}