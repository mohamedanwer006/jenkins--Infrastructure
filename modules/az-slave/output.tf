output "az-sg-name" {
  value = "azure resource group => ${azurerm_resource_group.rg.name}"
}
output "az-salve-ip" {
  value = "azure salve public ip => ${azurerm_linux_virtual_machine.Jenkins_slave_vm.public_ip_address}"
}