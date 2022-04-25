
# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "Jenkins-slave-rg"
  location = "East US"
}

resource "azurerm_linux_virtual_machine" "Jenkins_slave_vm" {
  name                = "Jenkins-slave-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  user_data = var.vm_user_data
  network_interface_ids = [
    azurerm_network_interface.jenkins-slave-interface.id,
  ]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("~/.ssh/jenkins_key_pair.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}