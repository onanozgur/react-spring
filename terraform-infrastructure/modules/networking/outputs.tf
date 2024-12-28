output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}

output "frontend_subnet_id" {
  value = azurerm_subnet.frontend.id
}
