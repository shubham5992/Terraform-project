

data "azurerm_client_config" "current"{}

resource "azurerm_key_vault" "appvault" {
  name      = "appvault78844423w3234"
  location            = azurerm_resource_group.rg-name.location
  resource_group_name = azurerm_resource_group.rg-name.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get","Set"
    ]    
  }
  depends_on = [
    azurerm_resource_group.rg-name
  ]
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword01"
  value        = "MySecretKey@04536"
  key_vault_id = azurerm_key_vault.appvault.id
  depends_on = [
    azurerm_key_vault.appvault
  ]
}

