variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "vm_name" {
  description = "Name of the VM"
  type = list(string)
  default = [ "frontend1", "frontend2", "backend1", "backend2" ]

}

data "azurerm_network_watcher" "test" {
  name                = "NetworkWatcher_eastus"
  resource_group_name = "NetworkWatcherRG"
}