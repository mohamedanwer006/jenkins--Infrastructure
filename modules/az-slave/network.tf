
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "jenkins-slave-net" {
  name                = "Jenkins-salve-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.jenkins-slave-net.name
  address_prefixes     = ["10.0.2.0/24"]
}

# create public ip address
resource "azurerm_public_ip" "pip" {
  name                = "jenkins-slave-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

# assign the public ip to the virtual network
resource "azurerm_network_interface" "jenkins-slave-interface" {
  name                = "jenkins-slave-nic1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
# assign private ip to the virtual network 
resource "azurerm_network_interface" "internal" {
  name                      = "jenkins-slave-nic2"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

