/*
*************************************************************
*               slave security group  
*************************************************************
*/

resource "azurerm_network_security_group" "jenkins_slave_sg" {
  name                = "Jenkins slave"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



locals {
  /*
*************************************************************
*               Inbound traffic 
*************************************************************
*/
  in_sg_rules = {

    ssh = {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    },

    http = {
      name                       = "http"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    },

    https = {
      name                       = "http"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    }

  }
  /*
*************************************************************
*               Outbound traffic 
*************************************************************
*/
  out_sg_rules = {

    ssh = {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    },
    // allow http and https for install software
    http = {
      name                       = "http"
      priority                   = 201
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    },

    https = {
      name                       = "http"
      priority                   = 201
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      access                      = "Allow"
    }
  }
}



resource "azurerm_network_security_rule" "jenkins_slave_security_rule_in" {
  network_security_group_name= azurerm_network_security_group.jenkins_slave_sg.name
  for_each                   = local.in_sg_rules
  name                       = each.key
  resource_group_name        = azurerm_resource_group.rg.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  access                      = each.value.access

  
}

resource "azurerm_network_security_rule" "jenkins_slave_security_rule_out" {
  network_security_group_name= azurerm_network_security_group.jenkins_slave_sg.name
  for_each                   = local.out_sg_rules
  name                       = each.key
  resource_group_name        = azurerm_resource_group.rg.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  access                      = each.value.access
}




resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.jenkins_slave_sg.id
}
