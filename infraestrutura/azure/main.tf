terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Criando grupo de recursos
resource "azurerm_resource_group" "kubernetes-group" {
  name     = "kubernetes-resources"
  location = "West US 2"
}

# Criando VNET
resource "azurerm_virtual_network" "kubernetes-vnet" {
  name                = "kubernetesVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name
}

# Criando sub-rede
resource "azurerm_subnet" "kubernetes-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.kubernetes-group.name
  virtual_network_name = azurerm_virtual_network.kubernetes-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Criando endereços IP Públicos
resource "azurerm_public_ip" "master-ip" {
  name                = "master-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "worker1-ip" {
  name                = "worker1-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "worker2-ip" {
  name                = "worker2-pub-ip"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# Criando interfaces de rede.
resource "azurerm_network_interface" "net-interface1" {
  name                = "nic1"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master-ip.id
  }
}

resource "azurerm_network_interface" "net-interface2" {
  name                = "nic2"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker1-ip.id
  }
}

resource "azurerm_network_interface" "net-interface3" {
  name                = "nic3"
  location            = azurerm_resource_group.kubernetes-group.location
  resource_group_name = azurerm_resource_group.kubernetes-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.kubernetes-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker2-ip.id
  }
}

# Criando máquina virtuais linux
resource "azurerm_linux_virtual_machine" "master_node" {
  name                = "master_node"
  computer_name       = "masternode"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_D2s_v3"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface1.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker-node1" {
  name                = "worker_node1"
  computer_name       = "workernode1"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_D2s_v3"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface2.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "worker-node2" {
  name                = "worker_node2"
  computer_name       = "workernode2"
  resource_group_name = azurerm_resource_group.kubernetes-group.name
  location            = azurerm_resource_group.kubernetes-group.location
  size                = "Standard_F2s_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.net-interface3.id
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/azure.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

output "master-ip" {
  value = azurerm_public_ip.master-ip.ip_address
}

output "workernode1-ip" {
  value = azurerm_public_ip.worker1-ip.ip_address
}

output "workernode2-ip" {
  value = azurerm_public_ip.worker2-ip.ip_address
}