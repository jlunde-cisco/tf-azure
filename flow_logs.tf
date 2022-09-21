resource "azurerm_storage_account" "test" {
  name                = "tetrationstrg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_log_analytics_workspace" "test" {
  name                = "acctestlaw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_network_watcher_flow_log" "test" {
  network_watcher_name = data.azurerm_network_watcher.test.name
  resource_group_name = "NetworkWatcherRG"
  name                 = "flow-log"
  version = 2

  network_security_group_id = azurerm_network_security_group.nsg_wide_open.id
  storage_account_id        = azurerm_storage_account.test.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }
}